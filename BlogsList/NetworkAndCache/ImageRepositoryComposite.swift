
/*
 Tries fetching from Local Cahce, if not found, fetches it from server
 */

import Foundation
import DataModel

final class ImageRepositoryComposite: ImageRepository {
    private let primarySource: ImageRepository
    private let secondarySource: ImageRepository
    public init(primarySource: ImageRepository, secondarySource: ImageRepository) {
        self.primarySource = primarySource
        self.secondarySource = secondarySource
    }
    func getImageFromURL(url: URL, completion: @escaping (Image) -> Void) -> Cancellable? {
        var cancellable: Cancellable?
        cancellable = primarySource.getImageFromURL(url: url) {[weak self] image  in
            if let _ = image.imageData {
                completion(image)
            } else {
                cancellable = self?.secondarySource.getImageFromURL(url: url) {image in
                    completion(image)
                }
            }
        }
        return cancellable
    }
}
