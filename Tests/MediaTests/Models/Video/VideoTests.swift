//
//  VideoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

import AVFoundation
@testable import MediaCore
import Photos
import XCTest

final class VideoTests: XCTestCase {
    let videoManager = MockVideoManager()
    let mockAsset = MockPHAsset()
    lazy var video = Video(phAsset: mockAsset)

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        PHAssetChanger.photoLibrary = MockPhotoLibrary()

        Video.videoManager = videoManager
        videoManager.avPlayerItemToReturn = nil
        videoManager.avAssetToReturn = nil
        videoManager.infoToReturn = nil

        MockPHAsset.fetchResult.mockAssets.removeAll()

        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil

        mockAsset.localIdentifierToReturn = ""
        mockAsset.mediaTypeToReturn = .image
        mockAsset.mediaSubtypesToReturn = []
        mockAsset.contentEditingInputToReturn = nil

        video.phAssetWrapper.value = mockAsset
    }

    func testWithIdentifierExists() {
        do {
            let localIdentifier = "TestIdentifier"
            mockAsset.localIdentifierToReturn = localIdentifier
            mockAsset.mediaTypeToReturn = .video
            MockPHAsset.fetchResult.mockAssets = [mockAsset]
            let video = try Video.with(identifier: .init(stringLiteral: localIdentifier))
            XCTAssertNotNil(video)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testWithIdentifierNotExists() {
        do {
            let video = try Video.with(identifier: .init(stringLiteral: "Bloal"))
            XCTAssertNil(video)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFavoriteSuccess() {
        let expectation = self.expectation(description: "VideoFavoriteResult")

        let isFavorite = true
        var result: Result<Void, Error>?
        video.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid video favorite result")
        }
    }

    func testFavoriteFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        let expectation = self.expectation(description: "VideoFavoriteResult")

        let isFavorite = true
        var result: Result<Void, Error>?
        video.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid video favorite result")
        }
    }

    func testPlayerItemSuccess() {
        guard let pathExtension = Video.FileType.mov.pathExtensions.first else {
            XCTFail("Could not fetch mov path extension")
            return
        }

        guard let url = URL(string: "file://test.\(pathExtension)") else {
            XCTFail("Could not create URL")
            return
        }

        videoManager.avPlayerItemToReturn = AVPlayerItem(url: url)

        let expectation = self.expectation(description: "PlayerItemResult")
        var result: Result<AVPlayerItem, Error>?
        video.playerItem { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid player item result")
        }
    }

    func testPlayerItemFailure() {
        videoManager.infoToReturn = [PHImageErrorKey: Media.Error.unknown]

        let expectation = self.expectation(description: "PlayerItemResult")
        var result: Result<AVPlayerItem, Error>?
        video.playerItem { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid player item result")
        }
    }

    func testAVAssetSuccess() {
        guard let pathExtension = Video.FileType.mov.pathExtensions.first else {
            XCTFail("Could not fetch mov path extension")
            return
        }

        guard let url = URL(string: "file://test.\(pathExtension)") else {
            XCTFail("Could not create URL")
            return
        }

        videoManager.avAssetToReturn = AVAsset(url: url)

        let expectation = self.expectation(description: "AVAssetResult")
        var result: Result<AVAsset, Error>?
        video.avAsset { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid av asset result")
        }
    }

    func testAVAssetFailure() {
        videoManager.infoToReturn = [PHImageErrorKey: Media.Error.unknown]

        let expectation = self.expectation(description: "AVAssetResult")
        var result: Result<AVAsset, Error>?
        video.avAsset { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid av asset result")
        }
    }

    func testMetadata() {
        XCTAssertNotNil(video.metadata)
    }

    func testSubtypes() {
        mockAsset.mediaSubtypesToReturn = .videoHighFrameRate
        XCTAssertEqual(video.subtypes.count, 1)
    }

    @available(iOS 13, *)
    func testVideoPropertiesSuccess() {
        do {
            videoManager.avAssetToReturn = AVMovie()

            let url = try createMockImage()

            let contentEditingInput = MockPHContentEditingInput()
            contentEditingInput.fullSizeImageURLToReturn = url
            mockAsset.contentEditingInputToReturn = contentEditingInput

            let expectation = self.expectation(description: "PropertiesResult")

            var res: Result<Video.Properties, Error>?
            video.properties { result in
                res = result
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1)

            let properties = try res?.get()
            XCTAssertNotNil(properties)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testVideoPropertiesFailure() {
        video.phAssetWrapper.value = nil

        let expectation = self.expectation(description: "PropertiesResult")

        var res: Result<Video.Properties, Error>?
        video.properties { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch res {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, Media.Error.noUnderlyingPHAssetFound)
        default:
            XCTFail("Invalid result")
        }
    }
}
