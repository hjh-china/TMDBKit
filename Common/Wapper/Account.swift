//
//  Account.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

// MARK: - [Account API](https://developers.themoviedb.org/3/account).
extension TMDBManager {
    /// Get your account details.
    /// - Parameter completion: Completion handler.
    public func getDetails(completion: @escaping (ObjectReturn<TMDBUser>) -> ()) {
        performRequest(path: "/account", needAuthentication: true, completion: completion)
    }
    
    /// Get all of the lists created by an account. Will invlude private lists if you are the owner.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - Minimum: 1
    ///     - Maximum: 1000
    ///     - Default: 1
    ///   - completion: Completion handler.
    public func getCreatedLists(accountId account: Int, language: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBList>>) -> ()) {
        performRequest(path: "/account/\(account)/lists",
                       language: language,
                       sortBy: nil,
                       page: page,
                       completion: completion)
    }
    
    /// Get the list of your favorite movies.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getFavoriteMovies(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
        performRequest(path: "/account/\(account)/favorite/movies",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    /// Get the list of your favorite TV shows.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getFavoriteTVShows(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
        performRequest(path: "/account/\(account)/favorite/tv",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    
    /// This method allows you to mark a movie or TV show as a favorite item.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - mediaObject: A `TMDBFavoriteMediaObject` which will be encoded into JSON as HTTP request body.
    ///   - completion: Completion handler.
    public func markAsFavorite(accountId: Int, mediaObject: TMDBFavoriteMediaObject, completion: @escaping (NilReturn) -> () ) {
        performRequest(postPath: "/account/\(accountId)/favorite",
                       dataObject: mediaObject,
                       expectedStatusCode: mediaObject.favorite ? 201 : 200,
                       completion: completion)
    }
    
    /// Get a list of all the movies you have rated.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getRatedMovies(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
        performRequest(path: "/account/\(account)/rated/movies",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    /// Get a list of all the TV shows you have rated.
    /// - TODO: TMDBTVShow CodingKeys
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getRatedTVShows(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
        performRequest(path: "/account/\(account)/rated/tv",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    /// Get a list of all the TV episodes you have rated.
    /// - TODO: TMDBTVShow CodingKeys
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getRatedTVEpisodes(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
        performRequest(path: "/account/\(account)/rated/episodes",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    /// Get a list of all the movies you have added to your watchlist.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getMovieWatchlist(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovie>>) -> ()) {
        performRequest(path: "/account/\(account)/watchlist/movies",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    /// Get a list of all the TV shows you have added to your watchlist.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getTVShowWatchlist(accountId account: Int, language: String? = nil, sortBy: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
        performRequest(path: "/account/\(account)/watchlist/tv",
                       language: language,
                       sortBy: sortBy,
                       page: page,
                       completion: completion)
    }
    
    /// Add a movie or TV show to your watchlist.
    ///
    /// - Parameters:
    ///   - accountId: Account ID for the user.
    ///   - mediaObject: A `TMDBWatchlistMediaObject` which will be encoded into JSON as HTTP request body.
    ///   - completion: Completion handler.
    public func addToWatchlist(accountId: Int, mediaObject: TMDBWatchlistMediaObject, completion: @escaping (NilReturn) -> () ) {
        performRequest(postPath: "/account/\(accountId)/watchlist",
                       dataObject: mediaObject,
                       expectedStatusCode: mediaObject.watchlist ? 201 : 200,
                       completion: completion)
    }
}
