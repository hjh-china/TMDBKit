//
//  TVEpisodes.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/25.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation


extension TMDBManager {
    /// [TV episodes API](https://developers.themoviedb.org/3/tv-episodes) wrapper class.
    /// - TODO:
    ///   - Append to response support.
    ///   - Changes model.
    public class TVEpisodesAPIWrapper: APIWrapper {
        /// Get the TV episode details by id.
        ///
        /// - Parameters:
        ///   - tvShow: TV show's ID.
        ///   - seasonNum: Season's number.
        ///   - episodeNum: Episode's number.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion hanlder.
        public func getDetails(forTVShow tvShow: Int,
                               seasonNum: Int,
                               episodeNum: Int,
                               language: String? = nil,
                               completion: @escaping ObjectHandler<TMDBTVEpisodeDetailed>) {
            performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/episode/\(episodeNum)",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Get the changes for a TV episode. By default only the last 24 hours are returned.
        ///
        /// You can query up to 14 days in a single query by using the start_date and end_date query parameters.
        ///
        /// - Parameters:
        ///   - tvEpisode: TV episode's ID.
        ///   - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
        ///   - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion hanlder.
        public func getChanges(forTVEpisode tvEpisode: Int,
                               from startDate: String? = nil,
                               to endDate: String? = nil,
                               page: Int? = nil,
                               completion: @escaping JSONHandler) {
            performRequest(path: "/tv/episode/\(tvEpisode)/changes",
                           query: queryMaker(startDate: startDate,
                                             endDate: endDate,
                                             page: page),
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
        ///   - episodeNum: Episode's number.
        ///   - authentication: Authentication type. **Accepted values:** `.user`, `.guest`.
        ///   - completion: Completion hanlder.
        public func getAccountStates(forTVShow tvShow: Int,
                                     seasonNum: Int,
                                     episodeNum: Int,
                                     authentication: TMDBAuthenticationType,
                                     completion: @escaping JSONInitableHandler<TMDBAccountStete>) {
            guard authentication != .noAuthentication else {
                completion(.fail(error: "Get account states needs authentication.".error(domain: "tv")))
                return
            }
            performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/episode/\(episodeNum)/account_states",
                           authentication: authentication,
                           completion: completion)
        }
        
        /// Get the credits (cast, crew and guest stars) for a TV episode.
        ///
        /// - Parameters:
        ///   - tvShow: TV show's ID.
        ///   - seasonNum: Season's number.
        ///   - episodeNum: Episode's number.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion hanlder.
        public func getCredits(forTVShow tvShow: Int,
                               seasonNum: Int,
                               episodeNum: Int,
                               language: String? = nil,
                               completion: @escaping ObjectHandler<TMDBTVEpisodeCredits>) {
            performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/episode/\(episodeNum)/credits",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Get the external ids for a TV episode. We currently support the following external sources.
        ///
        /// External Sources:
        /// - IMDB ID
        /// - Freebase MID
        /// - Freebase ID
        /// - TVDB ID
        /// - TVRage ID
        ///
        ///
        /// - Parameters:
        ///   - tvShow: TV show's ID.
        ///   - seasonNum: Season's number.
        ///   - episodeNum: Episode's number.
        ///   - completion: Completion hanlder.
        public func getExternalIds(forTVShow tvShow: Int,
                                   seasonNum: Int,
                                   episodeNum: Int,
                                   completion: @escaping ObjectHandler<TMDBExternalIds>) {
            performRequest(path: "/tv/\(tvShow)/season/\(seasonNum)/episode/\(episodeNum)/external_ids",
                           completion: completion)
        }
        
        /// Get the images that belong to a TV episode.
        ///
        /// - NOTE: [TMDB API doc](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-images)
        /// says there's a `include_image_language` parameter, yet there is no such parameter in the
        /// "Query String" section. And I tested myself, and this parameter seems not working. So please
        /// let me know if you know how this works.
        ///
        /// - Parameters:
        ///   - tvShow: TV show's ID.
        ///   - seasonNum: Season's number.
        ///   - episodeNum: Episode's number.
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
                              episodeNum: Int,
                              language: String? = nil,
                              includeImageLanguage: String? = nil,
                              completion: @escaping ObjectHandler<TMDBStills>) {
            var query = queryMaker(language: language)
            if let includeImageLanguage = includeImageLanguage {
                query["include_image_language"] = includeImageLanguage
            }
            performRequest(path: "/tv/\(tvShow)/sesson/\(seasonNum)/episode/\(episodeNum)/images",
                           query: query,
                           completion: completion)
        }
        
        
        
        /// Get the videos that have been added to a TV episode.
        ///
        /// - Parameters:
        ///   - tvShow: TV show's ID.
        ///   - seasonNum: Season's number.
        ///   - episodeNum: Episode's number.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getVideos(forTVShow tvShow: Int,
                              seasonNum: Int,
                              episodeNum: Int,
                              language: String? = nil,
                              completion: @escaping ObjectHandler<TMDBVideos>) {
            performRequest(path: "/tv/\(tvShow)/sesson/\(seasonNum)/videos",
                           query: queryMaker(language: language),
                           completion: completion)
        }
    }
}
