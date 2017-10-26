//
//  Find.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [Find API](https://developers.themoviedb.org/3/find) wrapper class.
public class TMKFindAPIWrapper: TMKAPIWrapper {
    /// The find method makes it easy to search for objects in our database by an external id. For instance,
    /// an IMDB ID.
    ///
    /// This method will search all objects (movies, TV shows and people) and return the results in a
    /// single response.
    ///
    /// The supported external sources for each object are as follows.
    /// - **IMDB ID:** movies, TV Shows, TV Episodes, people
    /// - **Freebase MID:** TV Shows, TV Seasons, TV Episodes, people
    /// - **Freebase ID:** TV Shows, TV Seasons, TV Episodes, people
    /// - **TVDB ID:** TV Shows, TV Seasons, TV Episodes
    /// - **TVRage ID:** TV Shows, TV Seasons, TV Episodes, people
    /// - Parameters:
    ///   - externalDource: Type of external ID.
    ///   - externalId: External ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: ([a-z]{2})-([A-Z]{2})
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func find(byExternalId externalId: String,
                     externalDource: ExternalSource,
                     language: String? = nil,
                     completion: @escaping TMKJSONInitableHandler<TMDBFindResult>) {
        var query = queryMaker(language: language)
        query["external_source"] = externalDource.rawValue
        performRequest(path: "/find/\(externalId)",
                       query: query,
                       completion: completion)
    }
    
    public enum ExternalSource: String {
        case imdbId = "imdb_id"
        case freebaseMid = "freebase_mid"
        case freebaseId = "freebase_id"
        case tvdbId = "tvdb_id"
        case tvrageId = "tvrage_id"
    }
}
