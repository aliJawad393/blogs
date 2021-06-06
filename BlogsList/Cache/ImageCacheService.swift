//
//  ImageCache.swift
//  DataModel
//
//  Created by Ali Jawad on 03/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel

final class ImageCacheService: ImageRepository, ImagePersistance {
    private let cache: NSCache<NSString, NSData>
    
    init(cache: NSCache<NSString, NSData>) {
        self.cache = cache
    }
    
    func getImageFromURL(url: URL, completion: @escaping (Image) -> Void) -> Cancellable? {
        completion(Image(imageData: cache.object(forKey: url.absoluteString as NSString) as Data?))
        return nil
    }
            
    func saveImage(url: URL, data: Image) {
        if let imageData = data.imageData {
            cache.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
        }
    }
}
