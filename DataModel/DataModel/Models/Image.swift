//
//  Image.swift
//  DataModel
//
//  Created by Ali Jawad on 03/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation

public struct Image {
    public let imageData: Data?
    
    public init(imageData: Data?) {
        self.imageData = imageData
    }
}
