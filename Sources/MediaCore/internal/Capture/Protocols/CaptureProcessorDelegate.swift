//
//  CaptureProcessorDelegate.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

import Foundation

@available(iOS 10, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
protocol CaptureProcessorDelegate: class {
    func didCapturePhoto(data: Data)
    func didCaptureLivePhoto(data: LivePhotoData)
}
