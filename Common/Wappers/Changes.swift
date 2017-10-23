//
//  Changes.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Changes API](https://developers.themoviedb.org/3/changes) wrapper class.
    public class ChangesAPIWrapper: APIWrapper {        
        /// Get a list of all of the movie ids that have been changed in the past 24 hours.
        ///
        /// You can query it for up to 14 days worth of changed IDs at a time with the `start_date` and `end_date` query parameters. 100 items are returned per page.
        /// - TODO: Use date formatter instead of string.
        /// - Parameters:
        ///     - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
        ///     - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
        ///     - page: Specify which page to query.
        ///         - minimum: 1
        ///         - maximum: 1000
        ///         - default: 1
        public func getMovieChangeList(startDate: String? = nil, endDate: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBChangesListItem>>) -> ()) {
            performRequest(path: "/movie/changes",
                           query: queryMaker(startDate: startDate,
                                             endDate: endDate,
                                             page: page),
                           completion: completion)
        }
        
        /// Get a list of all of the TV Show ids that have been changed in the past 24 hours.
        ///
        /// You can query it for up to 14 days worth of changed IDs at a time with the `start_date` and `end_date` query parameters. 100 items are returned per page.
        /// - TODO: Use date formatter instead of string.
        /// - Parameters:
        ///     - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
        ///     - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
        ///     - page: Specify which page to query.
        ///         - minimum: 1
        ///         - maximum: 1000
        ///         - default: 1
        public func getTVChangeList(from startDate: String? = nil, to endDate: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBChangesListItem>>) -> ()) {
            performRequest(path: "/tv/changes",
                           query: queryMaker(startDate: startDate,
                                             endDate: endDate,
                                             page: page),
                           completion: completion)
        }
        
        /// Get a list of all of the person ids that have been changed in the past 24 hours.
        ///
        /// You can query it for up to 14 days worth of changed IDs at a time with the `start_date` and `end_date` query parameters. 100 items are returned per page.
        /// - TODO: Use date formatter instead of string.
        /// - Parameters:
        ///     - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
        ///     - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
        ///     - page: Specify which page to query.
        ///         - minimum: 1
        ///         - maximum: 1000
        ///         - default: 1
        public func getPersonChangeList(from startDate: String? = nil, to endDate: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBChangesListItem>>) -> ()) {
            performRequest(path: "/person/changes",
                           query: queryMaker(startDate: startDate,
                                             endDate: endDate,
                                             page: page),
                           completion: completion)
        }
    }
}
