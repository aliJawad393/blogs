//
//  FlowSignIn.swift
//  BlogsList
//
//  Created by Ali Jawad on 06/06/2021.
//

import Foundation
final class FlowSignIn: Flow {
    var nextFlow: Flow?
    private let delegate: LoginDelegate
    
    init(delegate: LoginDelegate, nextFlow: Flow) {
        self.delegate = delegate
        self.nextFlow = nextFlow
    }
    
    func start() {
        delegate.loadLogInViewController(signUp: {[weak self] in
            self?.signUpAction()
        }, signIn: {[weak self] in
            self?.nextFlow?.start()
        })
    }
    
    private func signUpAction() {
        delegate.loadSignUpViewController(signUpBlock: {[weak self] _ in
            self?.nextFlow?.start()
        })
    }
}
