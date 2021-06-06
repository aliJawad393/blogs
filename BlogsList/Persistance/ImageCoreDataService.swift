//
//  FileManager.swift
//  BlogsList
//
//  Created by Ali Jawad on 05/06/2021.
//

import Foundation
import DataModel
import CoreData

final class ImageCoreDataService: ImageRepository, ImagePersistance {
    private let imageStorage: ExternalDataStorage
    private let managedObjectContext: NSManagedObjectContext
    
    //MARK: Init
    public init(imageStorage: ExternalDataStorage, managedObjectContext: NSManagedObjectContext) {
        self.imageStorage = imageStorage
        self.managedObjectContext = managedObjectContext
    }
    
    public func getImageFromURL(url: URL, completion: @escaping (Image) -> Void) -> Cancellable? {
        let fetchRequest : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url.absoluteString)
        do {
            let fetchedResult = try managedObjectContext.fetch(fetchRequest)
            if let post = fetchedResult.first, let imageUrl = post.imageUrl {
                completion(Image(imageData: imageStorage.getData(path: imageUrl)))
            } else {
                completion(Image(imageData: nil))
            }
        } catch {
            completion(Image(imageData: nil))
        }
        
        return nil
    }
    
    public func saveImage(url: URL, data: Image) throws {
        if let imageData = data.imageData {
            if let filePath = try imageStorage.writeData(data: imageData) {
                let fetchRequest : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url.absoluteString)
                let fetchedResult = try managedObjectContext.fetch(fetchRequest)
                if let post = fetchedResult.first {
                    post.imageUrl = filePath.absoluteString
                    try managedObjectContext.save()
                }
            }
            
        }
    }
}
