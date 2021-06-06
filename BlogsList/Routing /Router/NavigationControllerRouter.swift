//
//  NavigationControllerRouter.swift
//  BlogsList
//
//  Created by Ali Jawad on 06/06/2021.
//

import Foundation
import UIKit

class NavigationControllerRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private init() {
        fatalError("Can't initialize without reqired parameters")
    }
    
    func show(viewController: UIViewController)  {
        navigationController.pushViewController(viewController, animated: true)
    }}
