//
//  PHPickerResult+loadImage.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 14.10.20.
//

#if !os(tvOS) && !os(macOS)
import PhotosUI

@available(iOS 14, macCatalyst 14, *)
extension PHPickerResult {
    public enum Error: Swift.Error {
        case couldNotLoadObject(underlying: Swift.Error)
        case unknown
    }

    public func loadImage(_ completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            completion(.failure(Error.couldNotLoadObject(underlying: Error.unknown)))
            return
        }

        itemProvider.loadObject(ofClass: UIImage.self) { newImage, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(Error.couldNotLoadObject(underlying: error)))
                }
            } else if let newImage = newImage {
                DispatchQueue.main.async {
                    completion(.success(newImage as! UIImage))
                }
            }
        }
    }
}
#endif
