//
//  ViewCreator.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
struct ViewCreator {
    static func camera(for mediaTypes: Set<UIImagePickerController.MediaType>,
                       _ completion: @escaping ResultURLCompletion) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw Camera.Error.noCameraAvailable
        }

        return MediaPicker(sourceType: .camera, mediaTypes: mediaTypes) { value in
            guard case let MediaPickerValue.tookMedia(imageURL) = value else {
                completion(.failure(MediaPicker.Error.unsupportedValue))
                return
            }
            completion(.success(imageURL))
        }
    }

    static func browser<T: MediaProtocol>(mediaTypes: Set<UIImagePickerController.MediaType>,
                                          _ completion: @escaping ResultGenericCompletion<T>) throws -> some View {
        guard let sourceType = UIImagePickerController.availableSourceType else {
            throw MediaPicker.Error.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: mediaTypes) { value in
            guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                completion(.failure(MediaPicker.Error.unsupportedValue))
                return
            }
            let media = T.init(phAsset: phAsset)
            completion(.success(media))
        }
    }
}
#endif