//
//  PhotoLibrary.swift
//  Media
//
//  Created by Christian Elies on 07.12.19.
//

import Photos

typealias RequestAuthorizationHandler = (PHAuthorizationStatus) -> Void
typealias PerformChangesCompletionHandler = (Bool, Error?) -> Void

protocol PhotoLibrary: class {
    static func authorizationStatus() -> PHAuthorizationStatus
    static func requestAuthorization(_ handler: @escaping RequestAuthorizationHandler)
    @available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *)
    static func requestAuthorization(
        for accessLevel: PHAccessLevel,
        handler: @escaping RequestAuthorizationHandler
    )
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: PerformChangesCompletionHandler?)
    func register(_ observer: PHPhotoLibraryChangeObserver)
    func unregisterChangeObserver(_ observer: PHPhotoLibraryChangeObserver)
}
