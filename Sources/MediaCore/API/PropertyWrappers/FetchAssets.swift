//
//  FetchAssets.swift
//  
//
//  Created by Christian Elies on 03.12.19.
//

import Photos

/// Generic property wrapper for fetching assets from the photo library
/// Fetches the assets lazily (after accessing the property)
///
@propertyWrapper
public struct FetchAssets<T: MediaProtocol> {
    private let options = PHFetchOptions()
    private let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", T.type.rawValue)
    private let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)

    /// Wrapped array of objects conforming to the `MediaProtocol`
    public var wrappedValue: [T] { (try? PHAssetFetcher.fetchAssets(options: options)) ?? [] }

    /// Initializes the property wrapper using a default sort descriptor
    /// (sort by `creationDate descending`)
    ///
    public init() {
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
    }

    /// Initializes the property wrapper using the given predicate and sort descriptors
    /// to define the `PHFetchOptions`
    ///
    /// - Parameters:
    ///   - filter: a set of `MediaFilter` for filtering the assets
    ///   - sort: a set of `Sort<MediaSortKey>` for sorting the assets
    ///   - fetchLimit: a maximum number of results to fetch, defaults to 0 (no limit)
    ///   - includeAllBurstAssets: a Boolean value that determines whether the fetch result includes all assets from burst photo sequences, defaults to false
    ///   - includeHiddenAssets: a Boolean value that determines whether the fetch result includes assets marked as hidden, defaults to false
    ///
    public init(filter: Set<Media.Filter<T.MediaSubtype>> = [],
                sort: Set<Media.Sort<Media.SortKey>> = [],
                fetchLimit: Int = 0,
                includeAllBurstAssets: Bool = false,
                includeHiddenAssets: Bool = false) {
        if !filter.isEmpty {
            let predicates = filter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates + [mediaTypePredicate])
        } else {
            options.predicate = mediaTypePredicate
        }

        var sortKeys = sort
        sortKeys.insert(defaultSort)

        if !sortKeys.isEmpty {
            let sortDescriptors = sortKeys.map { $0.sortDescriptor }
            options.sortDescriptors = sortDescriptors
        }

        options.fetchLimit = fetchLimit
        options.includeAllBurstAssets = includeAllBurstAssets
        options.includeHiddenAssets = includeHiddenAssets
    }
}
