//
//  Media+Error.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

extension Media {
    /// General errors thrown by the framework
    ///
    public enum Error: Swift.Error {
        /// the operation was cancelled
        case cancelled
        /// an unknown error occurred
        case unknown
    }
}