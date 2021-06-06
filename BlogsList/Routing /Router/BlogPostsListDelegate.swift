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

final class BlogPostsNavigationControllerRouter: NavigationControllerRouter, BlogPostsListDelegate {
    private let factory: ViewControllerFactory
    
    //MARK: Init
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }
    
    func loadListsViewController(selectionCallBack: @escaping ItemSelection) {
        show(viewController: factory.blogPostsListViewController(selectionCallback: selectionCallBack))
    }
    
    func loadListDetailViewController(postId: Int) {
        show(viewController: factory.postDetailViewController(postId: postId))
    }
    
}
