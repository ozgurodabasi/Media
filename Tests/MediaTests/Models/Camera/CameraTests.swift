//
//  CameraTests.swift
//  MediaTests
//
//  Created by Christian Elies on 17.12.19.
//

#if canImport(UIKit) && !os(tvOS)
@testable import MediaCore
@testable import MediaSwiftUI
import XCTest

final class CameraTests: XCTestCase {
    @available(iOS 13, *)
    func testView() {
        do {
            let completion: Camera.ResultCameraResultCompletion = { _ in }
            _ = try Camera.view(completion)
            XCTFail("This should never happen because the simulator has no camera.")
        } catch {
            XCTAssertEqual(error as? Camera.Error, .noCameraAvailable)
        }
    }
}
#endif
