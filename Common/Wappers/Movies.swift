//
//  Movies.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Movies API](https://developers.themoviedb.org/3/movies) wrapper class.
    public class MoviesAPIWrapper {
        let manager = TMDBManager.shared
        
        public func getDetails(forMovie movie: Int, language: String? = nil, completion: @escaping (ObjectReturn<TMDBMovieDetailed>) -> ()) {
            manager.performRequest(path: "/movie/\(movie)",
                                   query: manager.queryMaker(language: language),
                                   completion: completion)
        }
        
        public func getAccountStates(forMovie movie: Int, authentication: TMDBManager.AuthenticationType, completion: @escaping (AnyReturn<TMDBAccountStete>) -> ()) {
            guard authentication != .noAuthentication else {
                completion(.fail(error: "Get account states needs authentication.".error(domain: "movies")))
                return
            }
            manager.performRequest(path: "/movie/\(movie)/account_states",
                                   authentication: authentication) { (result: JSONReturn) in
                switch result {
                case .success(let json):
                    if let accountState = TMDBAccountStete(fromJSON: json) {
                        completion(.success(any: accountState))
                    } else {
                        completion(.fail(error: "Cannot init account state object from data returned from TMDB.".error(domain: "movies")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
        
        public func getAlternativeTitles(forMovie movie: Int, country: String? = nil, completion: @escaping (ObjectReturn<TMDBAlternativeTitles>) -> ()) {
            manager.performRequest(path: "/movie/\(movie)/alternative_titles",
                                   query: manager.queryMaker(country: country),
                                   completion: completion)
        }
        
        public func getChanges(forMovie movie: Int, from startDate: String? = nil, to endDate: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<[TMDBChanges]>) -> ()) {
            manager.performRequest(path: "/movie/\(movie)/changes",
                                   query: manager.queryMaker(page: page,
                                                             startDate: startDate,
                                                             endDate: endDate)) { (result: ObjectReturn<[String: [TMDBChanges]]>) in
                switch result {
                case .success(let _results):
                    if let results = _results["changes"] {
                        completion(.success(object: results))
                    } else {
                        completion(.fail(error: "Error get changes for movie.".error(domain: "movies")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }

        public func getCredits(forMovie movie: Int, completion: @escaping (JSONReturn) -> ()) {
            manager.performRequest(path: "/movie/\(movie)/credits",
                                   completion: completion)
        }

        /// Get the images that belong to a movie.
        ///
        /// Querying images with a `language` parameter will filter the results.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: ([a-z]{2})-([A-Z]{2})
        ///     - default: en-US
        ///   - includeImageLanguage: If you want to include a fallback language (especially useful for backdrops) you can use the `includeImageLanguage` parameter. This should be a comma seperated value like so:
        ///     ```
        ///     let includeImageLanguage = "en,null"
        ///     ```
        ///   - completion: Completion handler.
        public func getImages(forMovie movie: Int, language: String? = nil, includeImageLanguage: String? = nil, completion: @escaping (ObjectReturn<TMDBMovieImages>) -> ()) {
            var query = manager.queryMaker(language: language)
            if let includeImageLanguage = includeImageLanguage {
                query["include_image_language"] = includeImageLanguage
            }
            manager.performRequest(path: "/movie/\(movie)/images",
                                   query: query,
                                   completion: completion)
        }
        
        public func getKeywords(forMovie movie: Int, completion: @escaping (ObjectReturn<TMDBKeywords>) -> ()) {
            manager.performRequest(path: "movie/\(movie)/keywords",
                                   completion: completion)
        }
        
        public func getReleaseDates(forMovie movie: Int, completion: @escaping (ObjectReturn<TMDBReleaseDates>) -> ()) {
            manager.performRequest(path: "/movie/\(movie)/release_dates",
                                   completion: completion)
        }
        
        public func getVideos(forMovie movie: Int, language: String? = nil, completion: @escaping (ObjectReturn<TMDBVideos>) -> ()) {
            manager.performRequest(path: "/movie/{movie_id}/videos",
                                   query: manager.queryMaker(language: language),
                                   completion: completion)
        }
    }
}
