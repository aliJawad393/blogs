
/*
 Fetches Image from Network and Saves to Local Cache
 */

import Foundation
import DataModel

final class ImageNetworkPersistanceDecorator: ImageRepository {
    private let imageSource: ImageRepository
    private let persistance: ImagePersistance
    
    public init(imageSource: ImageRepository, persistance: ImagePersistance) {
        self.imageSource = imageSource
        self.persistance = persistance
    }
    public func getImageFromURL(url: URL, completion: @escaping (Image) -> Void) -> Cancellable? {
        return imageSource.getImageFromURL(url: url) {[weak self] image  in
            try? self?.persistance.saveImage(url: url, data: image)
            completion(image)
        }
    }
}
