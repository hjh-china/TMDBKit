//
//  Collections.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Collections API](https://developers.themoviedb.org/3/collections) wrapper class.
    public class CollectionsAPIWrapper: APIWrapper {
        /// Get collection details by id.
        ///
        /// - Parameters:
        ///   - collectionId: Collection's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: ([a-z]{2})-([A-Z]{2})
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getDetails(forCollection collectionId: Int,
                               language: String? = nil,
                               completion: @escaping ObjectHandler<TMDBCollection>) {
            performRequest(path: "/collection/\(collectionId)",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Get the images for a collection by id.
        ///
        /// - Parameters:
        ///   - collectionId: Collection's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: ([a-z]{2})-([A-Z]{2})
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getImages(forCollection collectionId: Int,
                              language: String? = nil,
                              completion: @escaping ObjectHandler<TMDBImages>) {
            performRequest(path: "/collection/\(collectionId)",
                           query: queryMaker(language: language),
                           completion: completion)
        }
    }
}
