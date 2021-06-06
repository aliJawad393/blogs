//
//  ImageCache.swift
//  BlogsList
//
//  Created by Ali Jawad on 30/05/2021.
//

import Foundation
import UIKit

class ImageCache {
    private init() {}
    static let shared = NSCache<NSString, UIImage>()
}
