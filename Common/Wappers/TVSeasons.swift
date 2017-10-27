//
//  TVSeasons.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/25.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [TV seasons API](https://developers.themoviedb.org/3/tv-seasons) wrapper class.
/// - TODO:
///   - Append to response support.
///   - Changes model.
public class TMKTVSeasonsAPIWrapper: TMKAPIWrapper {
    /// Get the TV season details by id.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - seasonNum: Season's number.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getDetails(forTVShow tvShow: Int,
                           seasonNum: Int,
                           language: String? = nil,
                           completion: @escaping TMKObjectHandler<TMDBTVSeasonDetailed>) {
        performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the changes for a TV season. By default only the last 24 hours are returned.
    ///
    /// You can query up to 14 days in a single query by using the start_date and end_date query parameters.
    ///
    /// - Parameters:
    ///   - tvSeason: TV season's ID.
    ///   - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
    ///   - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion hanlder.
    public func getChanges(forTVSeason tvSeason: Int,
                           from startDate: String? = nil,
                           to endDate: String? = nil,
                           page: Int? = nil,
                           completion: @escaping TMKJSONHandler) {
        performRequest(path: "/tv/season/\(tvSeason)/changes",
                       query: queryMaker(startDate: startDate, endDate: endDate, page: page),
                       completion: completion)
    }
    
    /// Grab the following account states for a session:
    ///
    /// - TV show rating
    /// - If it belongs to your watchlist
    /// - If it belongs to your favourite list
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - seasonNum: Season's number.
    ///   - authentication: Authentication type. **Accepted values:** `.user`, `.guest`.
    ///   - completion: Completion hanlder.
    public func getAccountStates(forTVShow tvShow: Int,
                                 seasonNum: Int,
                                 authentication: TMDBAuthenticationType,
                                 completion: @escaping TMKJSONInitableHandler<TMDBAccountStete>) {
        guard authentication != .noAuthentication else {
            completion(.fail(data: nil, error: "Get account states needs authentication.".error(domain: "tv")))
            return
        }
        performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/account_states",
                       authentication: authentication,
                       completion: completion)
    }
    
    /// Get the credits for TV season.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - seasonNum: Season's number.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getCredits(forTVShow tvShow: Int,
                           seasonNum: Int,
                           language: String? = nil,
                           completion: @escaping TMKObjectHandler<TMDBCreditsBasic>) {
        performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/credits",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the external ids for a TV season. We currently support the following external sources.
    ///
    /// External Sources:
    /// - Freebase MID
    /// - Freebase ID
    /// - TVDB ID
    /// - TVRage ID
    ///
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - seasonNum: Season's number.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getExternalIds(forTVShow tvShow: Int,
                               seasonNum: Int,
                               language: String? = nil,
                               completion: @escaping TMKObjectHandler<TMDBExternalIds>) {
        performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/external_ids",
            query: queryMaker(language: language),
            completion: completion)
    }
    
    /// Get the images that belong to a TV season.
    ///
    /// - NOTE: [TMDB API doc](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    /// says there's a `include_image_language` parameter, yet there is no such parameter in the
    /// "Query String" section. And I tested myself, and this parameter seems not working. So please
    /// let me know if you know how this works.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - seasonNum: Season's number.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - includeImageLanguage: **See note above👆!** Querying images with a language parameter
    ///     will filter the results. If you want to include a fallback language (especially useful
    ///     for backdrops) you can use the `includeImageLanguage` parameter. This should be a comma
    ///     seperated value like so:
    ///     ``` swift
    ///     let includeImageLanguage = "en,null"
    ///     ```
    ///   - completion: Completion handler.
    public func getImages(forTVShow tvShow: Int,
                          seasonNum: Int,
                          language: String? = nil,
                          includeImageLanguage: String? = nil,
                          completion: @escaping TMKObjectHandler<TMDBPosters>) {
        var query = queryMaker(language: language)
        if let includeImageLanguage = includeImageLanguage {
            query["include_image_language"] = includeImageLanguage
        }
        performRequest(path: "/tv/\(tvShow)/sesson/\(seasonNum)/images",
                       query: query,
                       completion: completion)
    }
    
    /// Get the videos that have been added to a TV season.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - seasonNum: Season's number.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getVideos(forTVShow tvShow: Int,
                          seasonNum: Int,
                          language: String? = nil,
                          completion: @escaping TMKObjectHandler<TMDBVideos>) {
        performRequest(path: "/tv/\(tvShow)/sesson/\(seasonNum)/videos",
                       query: queryMaker(language: language),
                       completion: completion)
    }
}
