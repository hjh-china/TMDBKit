//
//  Genres.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/21.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Genres API](https://developers.themoviedb.org/3/genres) wrapper class.
    public class GenresAPIWrapper {
        /// Get the list of official genres for movies.
        ///
        /// - Parameters:
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///     - maxLength: 2
        ///   - completion: Completion handler.
        public func getMovieList(language: String? = nil, completion: @escaping (ObjectReturn<TMDBGenres>) -> ()) {
            TMDBManager.shared.performRequest(path: "/genre/movie/list",
                                              query: TMDBManager.shared.queryMaker(language: language),
                                              completion: completion)
        }
        
        /// Get the list of official genres for TV shows.
        ///
        /// - Parameters:
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: ([a-z]{2})-([A-Z]{2})
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getTVList(language: String? = nil, completion: @escaping (ObjectReturn<TMDBGenres>) -> ()) {
            TMDBManager.shared.performRequest(path: "/genre/tv/list",
                                              query: TMDBManager.shared.queryMaker(language: language),
                                              completion: completion)
        }
        
        /// - IMPORTANT: This method is **deprecated**.
        ///
        /// We highly recommend using [movie discover](https://developers.themoviedb.org/3/discover/movie-discover) instead of this method as it is much more flexible and will provide the same data with many more options and filters.
        ///
        /// - Parameters:
        ///   - genreId: Genre's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: ([a-z]{2})-([A-Z]{2})
        ///     - default: en-US
        ///   - includeAdult: Choose whether to inlcude adult (pornography) content in the results.
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`.
        ///   - completion: Completion handler.
        public func getMovies(byGenreId genreId: Int, language: String? = nil, includeAdult: Bool? = nil, sortBy: TMDBSortOption? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
            TMDBManager.shared.performRequest(path: "/genre/\(genreId)/movies",
                                              query: TMDBManager.shared.queryMaker(language: language,
                                                                                   sortBy: sortBy,
                                                                                   includeAdult: includeAdult),
                                              completion: completion)
        }
    }
}
