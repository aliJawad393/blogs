//
//  ServiceImageDownload.swift
//  DataModel
//
//  Created by Ali Jawad on 03/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel

final class ImageNetworkService: ImageRepository {
    private let queue: OperationQueue
    
    init(queue: OperationQueue) {
        self.queue = queue
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func getImageFromURL(url: URL, completion: @escaping (Image) -> Void) -> Cancellable? {
        let operation = ImageNetworkOperation(url: url) { data in
            completion(Image(imageData: data as Data?))
        }
        queue.addOperation(ImageNetworkOperation(url: url, completion: {image in
            completion(Image(imageData: image as Data?))
        }))
        
        return CancellableOperation(operation: operation)
    }
}


final class ImageNetworkOperation: Operation {
    let url: URL
    let completion: (NSData?) -> ()
    
    init(url: URL,
         completion: @escaping (NSData?) -> ()) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        let data = try? Data(contentsOf: url)
        guard let imageData = data else {return}
        if isCancelled {return}
        completion(imageData as NSData)
    }
}
