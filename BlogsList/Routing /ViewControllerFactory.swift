//
//  ViewControllerFactory.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import UIKit

public typealias ItemSelection = (Int)->()
protocol ViewControllerFactory {
    func blogPostsListViewController(selectionCallback:@escaping ItemSelection) -> UIViewController
    func postDetailViewController(postId: Int) -> UIViewController
}
