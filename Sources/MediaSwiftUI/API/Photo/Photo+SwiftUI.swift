//
//  Photo+SwiftUI.swift
//  Media
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import SwiftUI

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Photo {
    typealias ResultPhotoCameraResultCompletion = (Result<Camera.Result, Swift.Error>) -> Void

    /// Creates a ready-to-use `SwiftUI` view for capturing `Photo`s
    ///
    /// - Parameter completion: a closure which gets a `Result` (`Photo.Camera.Result` on `success` or `Error` on `failure`)
    ///
    static func camera(_ completion: @escaping ResultPhotoCameraResultCompletion) throws -> some View {
        try ViewCreator.camera(for: [.image]) { result in
            switch result {
            case .success(let cameraResult):
                switch cameraResult {
                case .tookPhoto(let image):
                    completion(.success(.tookPhoto(image: image)))
                default:
                    completion(.failure(Photo.Error.unsupportedCameraResult))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    ///
    /// - Parameter completion: a closure which gets a `Result` (`Photo` on `success` or `Error` on `failure`)
    ///
    static func browser(_ completion: @escaping ResultPhotoCompletion) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.image], completion)
    }
}
#endif

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Photo {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    /// - Parameter imageView: a post processing closure which gets the `SwiftUI` `Image` view for further modification, like applying modifiers
    ///
    func view<ImageView: View>(@ViewBuilder imageView: @escaping (Image) -> ImageView) -> some View {
        PhotoView(photo: self, imageView: imageView)
    }
}

#endif
