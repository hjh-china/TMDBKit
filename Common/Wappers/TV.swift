//
//  TV.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [TV API](https://developers.themoviedb.org/3/tv) wrapper class.
    /// - TODO: Append to response support.
    public class TVAPIWrapper: APIWrapper {
        /// Get the primary TV show details by id.
        ///
        /// - Parameters:
        ///   - tv: TV Show's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion hanlder.
        public func getDetails(forTV tv: Int,
                               language: String? = nil,
                               completion: @escaping (ObjectReturn<TMDBTVShowDetailed>) -> Void) {
            performRequest(path: "/tv/\(tv)",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Grab the following account states for a session:
        ///
        /// - TV show rating
        /// - If it belongs to your watchlist
        /// - If it belongs to your favourite list
        ///
        /// - Parameters:
        ///   - tv: TV Show's ID.
        ///   - authentication: Authentication type. **Accepted values:** `.user`, `.guest`.
        ///   - completion: Completion hanlder.
        public func getAccountStates(forTV tv: Int,
                                     authentication: TMDBAuthenticationType,
                                     completion: @escaping (JSONInitableReturn<TMDBAccountStete>) -> Void) {
            guard authentication != .noAuthentication else {
                completion(.fail(error: "Get account states needs authentication.".error(domain: "tv")))
                return
            }
            performRequest(path: "/tv/\(tv)/account_states",
                           authentication: authentication,
                           completion: completion)
        }
        
        /// Returns all of the alternative titles for a TV show.
        ///
        /// - Parameters:
        ///   - tv: TV Show's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion hanlder.
        public func getAlternativeTitles(forTV tv: Int,
                                         language: String? = nil,
                                         completion: @escaping (ObjectReturn<TMDBAlternativeTitles>) -> Void) {
            performRequest(path: "/tv/\(tv)/alternative_titles",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Get the changes for a TV show. By default only the last 24 hours are returned.
        ///
        /// You can query up to 14 days in a single query by using the start_date and end_date query parameters.
        
        /// TV show changes are different than movie changes in that there are some edits on seasons and episodes
        /// that will create a change entry at the show level. These can be found under the season and episode
        /// keys. These keys will contain a `series_id` and `episode_id`. You can use the
        /// [season changes](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-changes) and
        /// [episode changes](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-changes) methods to
        /// look these up individually.
        ///
        /// - TODO: TV show changes model (it's just TOO complacated😂).
        ///
        /// - Parameters:
        ///   - tv: TV Show's ID.
        ///   - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
        ///   - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion hanlder.
        public func getChanges(forTV tv: Int,
                               from startDate: String? = nil,
                               to endDate: String? = nil,
                               page: Int? = nil, completion: @escaping (ObjectReturn<TMDBTVShowChanges>) -> Void) {
            performRequest(
                path: "/tv/\(tv)/changes",
                query: queryMaker(startDate: startDate, endDate: endDate, page: page)
            ){ (result: ObjectReturn<[String: [TMDBTVShowChanges]]>) in
                switch result {
                case .success(let _results):
                    if let results = _results["changes"] {
                        completion(.success(object: results))
                    } else {
                        completion(.fail(error: "Error get changes for tv.".error(domain: "movies")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
        
        /// Get the list of content ratings (certifications) that have been added to a TV show.
        ///
        /// - Parameters:
        ///   - tv: TV Show's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion hanlder.
        public func getContentRatings(forTV tv: Int,
                                      language: String? = nil,
                                      completion: @escaping (ObjectReturn<TMDBContentRatings>) -> ()) {
            performRequest(path: "/tv/\(tv)/content_ratings",
                           query: queryMaker(language: language),
                           completion: completion)
        }
    }
}
