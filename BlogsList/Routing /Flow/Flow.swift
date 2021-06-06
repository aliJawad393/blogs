//
//  Flow.swift
//  BlogsList
//
//  Created by Ali Jawad on 06/06/2021.
//

import Foundation
public protocol Flow {
    var nextFlow: Flow? { get }
    func start()
}
