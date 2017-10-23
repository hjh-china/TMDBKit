//
//  Search.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Search API](https://developers.themoviedb.org/3/search) wrapper class.
    /// - TODO: Multi search.
    public class SearchAPIWrapper: APIWrapper {
        /// Search Companies.
        ///
        /// - Parameters:
        ///   - company: Pass a text query to search.
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func search(company: String, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBCompanyBasic>>) -> ()) {
            performRequest(path: "/search/company",
                           query: queryMaker(page: page, query: company),
                           completion: completion)
        }
        
        /// Search for collections.
        ///
        /// - Parameters:
        ///   - collection: Pass a text query to search.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func search(collection: String, language: String? = nil, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBCollectionBasic>>) -> ()) {
            performRequest(path: "/search/collection",
                           query: queryMaker(language: language, page: page, query: collection),
                           completion: completion)
        }
        
        /// Search Keywords.
        ///
        /// - Parameters:
        ///   - keyword: Pass a text query to search.
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func search(keyword: String, page: Int? = nil, completion: @escaping (ObjectReturn<TMDBPaged<TMDBKeyword>>) -> ()) {
            performRequest(path: "/search/keyword",
                           query: queryMaker(page: page, query: keyword),
                           completion: completion)
        }
        
        /// Search movies.
        ///
        /// - Parameters:
        ///   - movie: Pass a text query to search.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - includeAdult: Choose whether to inlcude adult (pornography) content in the results.
        ///   - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
        ///     - pattern: `^[A-Z]{2}$`
        ///   - completion: Completion handler.
        public func search(movie: String,
                           language: String? = nil,
                           page: Int? = nil,
                           includeAdult: Bool? = nil,
                           region: String? = nil,
                           year: Int? = nil,
                           primaryReleaseYear: Int? = nil,
                           completion: @escaping (ObjectReturn<TMDBPaged<TMDBCollectionBasic>>) -> ()) {
            var query = queryMaker(language: language,
                                   page: page,
                                   region: region,
                                   query: movie,
                                   includeAdult: includeAdult)
            if let year = year {
                query["year"] = "\(year)"
            }
            if let primaryReleaseYear = primaryReleaseYear {
                query["primary_release_year"] = "\(primaryReleaseYear)"
            }
            performRequest(path: "/search/collection", query: query, completion: completion)
        }
        
        /// Search people.
        ///
        /// - Parameters:
        ///   - person: Pass a text query to search.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - includeAdult: Choose whether to inlcude adult (pornography) content in the results.
        ///   - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
        ///     - pattern: `^[A-Z]{2}$`
        ///   - completion: Completion handler.
        public func search(person: String,
                           language: String? = nil,
                           page: Int? = nil,
                           includeAdult: Bool? = nil,
                           region: String? = nil,
                           completion: @escaping (AnyReturn<TMDBPersonWithKnownForMedia>) -> ()) {
            performRequest(path: "/search/person",
                           query: queryMaker(language: language,
                                             page: page,
                                             region: region,
                                             query: person,
                                             includeAdult: includeAdult)){ (result: JSONReturn) in
                switch result {
                case .success(let json):
                    do {
                        completion(.success(any: try TMDBPersonWithKnownForMedia(fromJSON: json)))
                    } catch let error {
                        completion(.fail(error: error))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
        
        /// Search TV Shows.
        ///
        /// - Parameters:
        ///   - tvShow: Pass a text query to search.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func search(tvShow: String,
                           language: String? = nil,
                           page: Int? = nil,
                           firstAirDateYear: Int? = nil,
                           completion: @escaping (ObjectReturn<TMDBPaged<TMDBTVShow>>) -> ()) {
            var query = queryMaker(language: language, page: page, query: tvShow)
            if let firstAirDateYear = firstAirDateYear {
                query["first_air_date_year"] = "\(firstAirDateYear)"
            }
            performRequest(path: "/search/collection",
                           query: query,
                           completion: completion)
        }
    }
}
