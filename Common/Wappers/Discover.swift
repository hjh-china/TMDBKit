//
//  Discover.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [Discover API](https://developers.themoviedb.org/3/discover) wrapper class.
public class TMKDiscoverAPIWrapper: TMKAPIWrapper {
    /// Discover movies by different types of data like average rating, number of votes, genres and
    /// certifications. You can get a valid list of certifications from the
    /// [certifications list method](https://developers.themoviedb.org/3/certifications/get-movie-certifications).
    ///
    /// Discover also supports a nice list of sort options. See below for all of the available options.
    ///
    /// Please note, when using certification \ certification.lte you must also specify certification_country.
    /// These two parameters work together in order to filter the results. You can only filter results with
    /// the countries we have added to our
    /// [certifications list](https://developers.themoviedb.org/3/certifications/get-movie-certifications).
    ///
    /// If you specify the region parameter, the regional release date will be used instead of the primary
    /// release date. The date returned will be the first date based on your query (ie. if a with_release_type
    /// is specified). It's important to note the order of the release types that are used. Specifying "2|3"
    /// would return the limited theatrical release date as opposed to "3|2" which would return the
    /// theatrical date.
    ///
    /// Also note that a number of filters support being comma (,) or pipe (|) separated. Comma's are treated
    /// like an AND and query while pipe's are an OR.
    ///
    /// Some examples of what can be done with discover can be found
    /// [here](https://www.themoviedb.org/documentation/api/discover).
    ///
    /// - Parameter options: Usage example:
    ///     ```swift
    ///     var options: [TMDBMovieDiscoverOption] = []
    ///     options.append(DiscoverOption(language: "zh"))
    ///     options.append(DiscoverOption(sortBy: .releaseDateAsc))
    ///     TMDBManager.shared.discovery.movieDiscover(options: options) { /* do someting... */ }
    ///     ```
    /// - Parameter page: Specify the page of results to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    /// - Parameter completion: Completion handler.
    public func movieDiscover(withOptions options: [TMDBMovieDiscoverOption],
                              inPage page: Int? = nil,
                              completion: @escaping TMKObjectHandler<TMDBPaged<TMDBMovieGeneral>>) {
        var query: [String: String] = [:]
        for option in options {
            query[option.key] = option.value
        }
        if let page = page {
            query["page"] = "\(page)"
        }
        performRequest(path: "/discover/movie",
                       query: query,
                       completion: completion)
    }
    
    /// Discover TV shows by different types of data like average rating, number of votes, genres, the network
    /// they aired on and air dates.
    ///
    /// Discover also supports a nice list of sort options. See below for all of the available options.
    ///
    /// Also note that a number of filters support being comma (,) or pipe (|) separated. Comma's are treated
    /// like an AND and query while pipe's are an OR.
    ///
    /// Some examples of what can be done with discover can be found here.
    ///  - Parameter options: Usage example:
    ///     ```swift
    ///     var options: [TMDBTVDiscoverOption] = []
    ///     options.append(DiscoverOption(language: "zh"))
    ///     options.append(DiscoverOption(sortBy: .releaseDateAsc))
    ///     TMDBManager.shared.discovery.movieDiscover(options: options) { /* do someting... */ }
    ///     ```
    /// - Parameter page: Specify the page of results to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    /// - Parameter completion: Completion handler.
    public func tvDiscover(withOptions options: [TMDBTVDiscoverOption],
                           inPage page: Int? = nil,
                           completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        var query: [String: String] = [:]
        for option in options {
            query[option.key] = option.value
        }
        if let page = page {
            query["page"] = "\(page)"
        }
        performRequest(path: "/discover/tv",
                       query: query,
                       completion: completion)
    }
}
