//
//  File.swift
//  BlogsList
//
//  Created by Ali Jawad on 29/05/2021.
//

import Foundation
import UIKit

public protocol BlogPostsListDelegate {
    func loadListsViewController(selectionCallBack:@escaping ItemSelection)
    func loadListDetailViewController(postId: Int)
}

final class NavigationControllerRouter: BlogPostsListDelegate {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    //MARK: Init
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func loadListsViewController(selectionCallBack: @escaping ItemSelection) {
        show(viewController: factory.blogPostsListViewController(selectionCallback: selectionCallBack))
    }
    
    func loadListDetailViewController(postId: Int) {
        show(viewController: factory.postDetailViewController(postId: postId))
    }
    
    //MARK: Private Helpers
    private func show(viewController: UIViewController)  {
        navigationController.pushViewController(viewController, animated: true)
    }
}
