//
//  UserCrentials.swift
//  DataModel
//
//  Created by Ali Jawad on 08/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
public struct UserCredentials {
    let name: String
    let email: String
    let password: String
    
    public init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
