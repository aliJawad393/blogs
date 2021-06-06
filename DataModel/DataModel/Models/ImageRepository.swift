//
//  ImageRepository.swift
//  DataModel
//
//  Created by Ali Jawad on 03/06/2021.
//  Copyright © 2021 Ali Jawad. All rights reserved.
//

import Foundation
public protocol ImageRepository {
    func getImageFromURL(url: URL, completion: @escaping(Image) -> Void) -> Cancellable?
}

public protocol ImagePersistance {
    func saveImage(url: URL, data: Image) throws
}
