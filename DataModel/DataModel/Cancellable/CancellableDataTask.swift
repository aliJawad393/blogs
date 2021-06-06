//
//  Cancellable.swift
//  DataModel
//
//  Created by Ali Jawad on 01/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation

final public class CancellableDataTask: Cancellable {
    var task: URLSessionDataTask
    
    public init(task: URLSessionDataTask) {
        self.task = task
    }
    
    public func cancelRequest() {
        self.task.cancel()
    }
}
