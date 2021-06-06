//
//  CancellableOperation.swift
//  DataModel
//
//  Created by Ali Jawad on 03/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation

final public class CancellableOperation: Cancellable {
    private let operation: Operation
    
    public init(operation: Operation) {
        self.operation = operation
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    public func cancelRequest() {
        operation.cancel()
    }
}
