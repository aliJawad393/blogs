//
//  iOSViewControllerFactory.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import Foundation
import UIKit
import DataModel
import Combine
import CoreData

final class iOSViewControllerFactory: ViewControllerFactory {
    private let parser: ParserProtocol
    private let session = URLSession.shared
    private let baseURL: URL
    private var cacheService = ImageCacheService(cache: NSCache<NSString, NSData>())
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    init(baseURL: URL, parser: ParserProtocol) {
        self.parser = parser
        self.baseURL = baseURL
    }
    
    private init() {
        fatalError("Can't be initialized without parameters")
    }
    
    func blogPostsListViewController(selectionCallback:@escaping ItemSelection) -> UIViewController {
        let networkService = PostsNetworkService(session: session, baseURL: baseURL, parser: parser, networkNotifier: getNetworkNotifier())
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        let persistanceServie = PostCoreDataService(managedObjectContext: context)
        let networkPersistanceDecorator = PostNetworkPersistanceDecorator(network: networkService, persistance:persistanceServie)
        let networkPersistanceComposite = PostNetworkPersistanceComposite(primarySource: networkPersistanceDecorator, secondary: persistanceServie)
        let dataItems = CurrentValueSubject<[PostsListPresenter], Never>([])
        let searchService = BlogPostsSearchConcrete(dataItems: dataItems, dataSource: networkPersistanceComposite)
        let viewModel = BlogPostsListConcreteViewModel(dataItems: dataItems, dataSource: networkPersistanceComposite, searchViewModel: searchService, networkNotifier: getNetworkNotifier(), imageSource: makeImageSource())
        let controller = BlogPostsListViewController(viewModel: viewModel, selection: selectionCallback)
        viewModel.view = controller
        return controller
    }
    
    func postDetailViewController(postId: Int) -> UIViewController {
        let networkService = PostsNetworkService(session: session, baseURL: baseURL, parser: parser, networkNotifier: getNetworkNotifier())
                
        //Post
        let postCoreDataPersistanceService = PostCoreDataService(managedObjectContext: persistentContainer.viewContext) // Save and fetch Post from core data
        
        let postNetworkPersistanceComposite = PostNetworkPersistanceComposite(primarySource: networkService, secondary: postCoreDataPersistanceService) // First fetch post from server, if fails, fetch from core data
        
        let viewModel = PostDetailViewModelConcrete(postId: postId, dataSource: postNetworkPersistanceComposite, imageSource: makeImageSource())
        let controller = PostDetailViewController(viewModel: viewModel)
        viewModel.view = controller
        return controller
    }
    
    //MARK: Private Helpers
    private func makeImageSource() -> ImageRepository {
        //Image
        let queue = OperationQueue()
        let networkImage = ImageNetworkService(queue: queue) // fetch image from network
        let imageCoreDataPersistanceService = ImageCoreDataService(imageStorage: DataStorageFile(fileManager: FileManager.default), managedObjectContext: persistentContainer.viewContext) // Store and fetch image from core data

        let imageNetworkPersistanceDecorator = ImageNetworkPersistanceDecorator(imageSource: networkImage, persistance: [cacheService ,imageCoreDataPersistanceService]) // fetch image from network and save to cache and core data
        
        let imageCachePersistanceComposite = ImageRepositoryComposite(primarySource: cacheService, secondarySource: imageCoreDataPersistanceService) // first fetc data from cache, if not found, fetch from core data
        
        let imagePersistaneNetworkComposite = ImageRepositoryComposite(primarySource: imageCachePersistanceComposite, secondarySource: imageNetworkPersistanceDecorator) // first fetch from cache, if fails, fetch from core data, if fails, fetch from server and save to core data
        return imagePersistaneNetworkComposite
    }
}
