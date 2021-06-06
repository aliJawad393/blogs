//
//  SceneDelegate.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import UIKit
import DataModel

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var app: BlogListApp?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let parser = ParseManager()
        let factory = iOSViewControllerFactory(baseURL: URL(string: "https://techcrunch.com/wp-json/wp/v2")!, parser: parser)
        let navigationController = UINavigationController()
        let router = NavigationControllerRouter(navigationController: navigationController, factory: factory)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        app = BlogListApp.start(delegate: router)

    }
}

