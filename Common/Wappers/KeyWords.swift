//
//  KeyWords.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Keywords API](https://developers.themoviedb.org/3/keywords) wrapper class.
    public class KeywordsAPIWrapper: APIWrapper {
        /// Get certain keyword's detail with its ID.
        ///
        /// - Parameters:
        ///   - keywordId: Keyword's ID.
        ///   - completion: Completion handler.
        public func getDetails(forKeywordId keywordId: Int,
                               completion: @escaping ObjectHandler<TMDBKeyword>) {
            performRequest(path: "/keyword/\(keywordId)", completion: completion)
        }
        
        /// Get the movies that belong to a keyword.
        ///
        /// We highly recommend using
        /// [movie discover](https://developers.themoviedb.org/3/discover/movie-discover) instead of this method
        /// as it is much more flexible.
        ///
        /// - Parameters:
        ///   - keywordId: Keyword's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - includeAdult: Choose whether to inlcude adult (pornography) content in the results.
        ///   - completion: Completion handler.
        public func getMovies(forKeywordId keywordId: Int,
                              language: String? = nil,
                              includeAdult: Bool? = nil,
                              completion: @escaping ObjectHandler<TMDBPaged<TMDBMovieGeneral>>) {
            performRequest(path: "/keyword/{keyword_id}/movies",
                           query: queryMaker(language: language, includeAdult: includeAdult),
                           completion: completion)
        }
    }
}
