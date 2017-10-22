//
//  Account.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Account API](https://developers.themoviedb.org/3/account) wrapper class.
    public class AccountAPIWrapper: APIWrapper {
        /// Get your account details.
        /// - Parameter completion: Completion handler.
        public func getDetails(completion: @escaping (ObjectReturn<TMDBUser>) -> ()) {
            manager.performRequest(path: "/account",
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get all of the lists created by an account. Will invlude private lists if you are the owner.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - Minimum: 1
        ///     - Maximum: 1000
        ///     - Default: 1
        ///   - completion: Completion handler.
        public func getCreatedLists(byAccount account: Int, language: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBList>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/lists",
                                   query: queryMaker(language: language,
                                                     sortBy: nil,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get the list of your favorite movies.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getFavoriteMovies(inAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/favorite/movies",
                                   query: queryMaker(language: language,
                                                     sortBy: sortBy,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get the list of your favorite TV shows.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getFavoriteTVShows(inAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/favorite/tv",
                                   query: queryMaker(language: language,
                                                     sortBy: sortBy,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        
        /// This method allows you to mark a movie or TV show as a favorite item.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - mediaObject: A `TMDBFavoriteMediaObject` which will be encoded into JSON as HTTP request body.
        ///   - completion: Completion handler.
        public func markAsFavorite(forAccount account: Int, mediaObject: TMDBFavoriteMediaObject, completion: @escaping (NilReturn) -> () ) {
            do {
            let data = try JSONEncoder().encode(mediaObject)
            manager.performRequest(method: "POST",
                                   path: "/account/\(account)/favorite",
                                   data: data,
                                   authentication: .user,
                                   expectedStatusCode: mediaObject.favorite ? 201 : 200,
                                   completion: completion)
            } catch let error {
                completion(.fail(error: error))
            }
        }
        
        /// Get a list of all the movies you have rated.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getRatedMovies(byAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/rated/movies",
                                   query: queryMaker(language: language,
                                                     sortBy: sortBy,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get a list of all the TV shows you have rated.
        /// - TODO: TMDBTVShow CodingKeys
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getRatedTVShows(byAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/rated/tv",
                                   query: queryMaker(language: language, sortBy: sortBy, page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get a list of all the TV episodes you have rated.
        /// - TODO: TMDBTVShow CodingKeys
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getRatedTVEpisodes(byAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/rated/episodes",
                                   query: queryMaker(language: language,
                                                     sortBy: sortBy,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get a list of all the movies you have added to your watchlist.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getMovieWatchlist(inAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/watchlist/movies",
                                   query: queryMaker(language: language,
                                                     sortBy: sortBy,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Get a list of all the TV shows you have added to your watchlist.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - sortBy: Sort the results. **Allowed Values:** `.createdAtAsc`, `.createdAtDesc`
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getTVShowWatchlist(inAccount account: Int, language: String? = nil, sortBy: TMDBSortOption? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
            manager.performRequest(path: "/account/\(account)/watchlist/tv",
                                   query: queryMaker(language: language,
                                                     sortBy: sortBy,
                                                     page: page),
                                   authentication: .user,
                                   completion: completion)
        }
        
        /// Add a movie or TV show to your watchlist.
        ///
        /// - Parameters:
        ///   - account: Account ID for the user.
        ///   - mediaObject: A `TMDBWatchlistMediaObject` which will be encoded into JSON as HTTP request body.
        ///   - completion: Completion handler.
        public func addToWatchlist(forAccount account: Int, mediaObject: TMDBWatchlistMediaObject, completion: @escaping (NilReturn) -> () ) {
            do {
                let data = try JSONEncoder().encode(mediaObject)
                manager.performRequest(method: "POST",
                                       path: "/account/\(account)/watchlist",
                                       data: data,
                                       authentication: .user,
                                       expectedStatusCode: mediaObject.watchlist ? 201 : 200,
                                       completion: completion)
            } catch let error {
                completion(.fail(error: error))
            }
            
        }
    }
}
