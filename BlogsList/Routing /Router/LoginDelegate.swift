//
//  LoginDelegate.swift
//  BlogsList
//
//  Created by Ali Jawad on 06/06/2021.
//

import Foundation
import UIKit

public protocol LoginDelegate {
    func loadLogInViewController(signUp: @escaping() -> (), signIn: @escaping()->())
    func loadSignUpViewController(signUpBlock: @escaping(UserCredentials)->())
}

final class LoginNavigationControllerRouter: NavigationControllerRouter, LoginDelegate {
    private let factory: ViewControllerFactory
    
    //MARK: Init
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }
    
    func loadLogInViewController(signUp: @escaping () -> (), signIn: @escaping()->()) {
        show(viewController: factory.loginViewController(signUp: signUp, login: signIn))
    }
    
    func loadSignUpViewController(signUpBlock: @escaping(UserCredentials)->()) {
        show(viewController: factory.signUpViewController(signUpBlock: signUpBlock))
    }
    
}
