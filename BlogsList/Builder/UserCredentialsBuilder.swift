//
//  UserCredentialsBuilder.swift
//  BlogsList
//
//  Created by Ali Jawad on 08/06/2021.
//

import Foundation
import DataModel

enum CredentialsError: Equatable, Error {
    case validationFailed(String)
}



protocol CredentialsBuilder {
    mutating func setName(name: String)
    mutating func setEmail(email: String) throws
    mutating func setPassword(password: String) throws
    mutating func setConfirmPassword(password: String) throws
    mutating func setTicked(isTicked: Bool)
    func build() throws -> UserCredentials
}

struct UserCrendentialsBuilder: CredentialsBuilder {
    private var name: String = ""
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    private var isTicked: Bool = false
    
    mutating func setName(name: String) {
        self.name = name
    }
    
    mutating func setEmail(email: String) throws {
        if email.isValidEmail() {
            self.email = email
        } else {
            throw CredentialsError.validationFailed("Invalid email")
        }
    }
    
    mutating func setPassword(password: String) throws {
        if password.count > 6 {
            self.password = password
        } else {
            throw CredentialsError.validationFailed("Password length shorter than required")
        }
    }
    
    mutating func setConfirmPassword(password: String) throws {
        if password.count > 0 && password == self.password {
            self.confirmPassword = password
        } else {
            throw CredentialsError.validationFailed("Passwords mismatch")
        }
    }
    
    mutating func setTicked(isTicked: Bool) {
        self.isTicked = isTicked
    }
    
    func build() throws -> UserCredentials{
        guard  email.count > 0 else {
            throw CredentialsError.validationFailed("Email is mandatory")
        }
        
        guard password.count > 0 else {
            throw CredentialsError.validationFailed("Password is missing")
        }
        
        guard confirmPassword.count > 0 else {
            throw CredentialsError.validationFailed("Confirm password")
        }
        
        return UserCredentials(name: name, email: email, password: password)
    }
}
