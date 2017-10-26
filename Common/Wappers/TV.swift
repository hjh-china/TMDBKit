//
//  TV.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [TV API](https://developers.themoviedb.org/3/tv) wrapper class.
/// - TODO:
///   - Append to response support.
///   - TV changes model.
public class TMKTVAPIWrapper: TMKAPIWrapper {
    /// Get the primary TV show details by id.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getDetails(forTVShow tvShow: Int,
                           language: String? = nil,
                           completion: @escaping TMKObjectHandler<TMDBTVShowDetailed>) {
        performRequest(path: "/tv/\(tvShow)",
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
    ///   - tvShow: TV show's ID.
    ///   - authentication: Authentication type. **Accepted values:** `.user`, `.guest`.
    ///   - completion: Completion hanlder.
    public func getAccountStates(forTVShow tvShow: Int,
                                 authentication: TMDBAuthenticationType,
                                 completion: @escaping TMKJSONInitableHandler<TMDBAccountStete>) {
        guard authentication != .noAuthentication else {
            completion(.fail(error: "Get account states needs authentication.".error(domain: "tv")))
            return
        }
        performRequest(path: "/tv/\(tvShow)/account_states",
                       authentication: authentication,
                       completion: completion)
    }
    
    /// Returns all of the alternative titles for a TV show.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getAlternativeTitles(forTVShow tvShow: Int,
                                     language: String? = nil,
                                     completion: @escaping TMKObjectHandler<TMDBAlternativeTitles>) {
        performRequest(path: "/tv/\(tvShow)/alternative_titles",
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
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
    ///   - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion hanlder.
    public func getChanges(forTVShow tvShow: Int,
                           from startDate: String? = nil,
                           to endDate: String? = nil,
                           page: Int? = nil,
                           completion: @escaping TMKObjectHandler<[TMDBTVShowChanges]>) {
        performRequest(
            path: "/tv/\(tvShow)/changes",
            query: queryMaker(startDate: startDate, endDate: endDate, page: page)
        ){ (result: TMKObjectReturn<[String: [TMDBTVShowChanges]]>) in
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
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getContentRatings(forTVShow tvShow: Int,
                                  language: String? = nil,
                                  completion: @escaping TMKObjectHandler<TMDBContentRatings>) {
        performRequest(path: "/tv/\(tvShow)/content_ratings",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the credits (cast and crew) that have been added to a TV show.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getCredits(forTVShow tvShow: Int,
                           language: String? = nil,
                           completion: @escaping TMKObjectHandler<TMDBCreditsBasic>) {
        performRequest(path: "/tv/\(tvShow)/credits",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the external ids for a TV show. We currently support the following external sources.
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
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion hanlder.
    public func getExternalIds(forTVShow tvShow: Int,
                               language: String? = nil,
                               completion: @escaping TMKObjectHandler<TMDBExternalIds>) {
        performRequest(path: "/tv/\(tvShow)/external_ids",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the images that belong to a movie.
    ///
    /// Querying images with a `language` parameter will filter the results.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getImages(forTVShow tvShow: Int,
                          language: String? = nil,
                          completion: @escaping TMKObjectHandler<TMDBImages>) {
        performRequest(path: "/tv/\(tvShow)/images",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the keywords that have been added to a TV show.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - completion: Completion handler.
    public func getKeywords(forTVShow tvShow: Int,
                            completion: @escaping TMKObjectHandler<TMDBKeywords>) {
        performRequest(path: "tv/\(tvShow)/keywords",
                       completion: completion)
    }
    
    /// Get the list of TV show recommendations for this item.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getRecommendations(forTVShow tvShow: Int,
                                   language: String? = nil,
                                   page: Int? = nil,
                                   completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        performRequest(path: "/tv/\(tvShow)/recommendations",
            query: queryMaker(language: language, page: page),
            completion: completion)
    }
    
    /// Get a list of seasons or episodes that have been screened in a film festival or theatre.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - completion: Completion handler.
    public func getScreenedTheatrically(forTVShow tvShow: Int,
                                        completion: @escaping TMKObjectHandler<TMDBScreenedTheatricallyShows>) {
        performRequest(path: "/tv/\(tvShow)/screened_theatrically",
                       completion: completion)
    }
    
    /// Get a list of similar TV shows. These items are assembled by looking at keywords and genres.
    ///
    /// These items are assembled by looking at keywords and genres.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getSimilar(forTVShow tvShow: Int,
                           language: String? = nil,
                           page: Int? = nil,
                           completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        performRequest(path: "/tv/\(tvShow)/similar",
            query: queryMaker(language: language, page: page),
            completion: completion)
    }
    
    /// Get a list of the translations that exist for a TV show.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - completion: Completion handler.
    public func getTranslations(forTVShow tvShow: Int,
                                completion: @escaping TMKObjectHandler<TMDBTranslations>) {
        performRequest(path: "/tv/\(tvShow)/translations", completion: completion)
    }
    
    /// Get the videos that have been added to a TV show.
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getVideos(forTVShow tvShow: Int,
                          language: String? = nil,
                          completion: @escaping TMKObjectHandler<TMDBVideos>) {
        performRequest(path: "/tv/\(tvShow)/videos",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Rate a TV show.
    ///
    /// A valid session or guest session ID is required. You can read more about how this works
    /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - rating: This is the value of the rating you want to submit. The value is expected to be
    /// between 0.5 and 10.0.
    ///     - minimum: 0.5
    ///     - maximum: 10
    ///   - authentication: Authentication type. Accepted `.user` or `.guest`.
    ///   - completion: Completion handler.
    public func rate(tvShow: Int,
                     rating: Double,
                     authentication: TMDBAuthenticationType,
                     completion: @escaping TMKHandler) {
        guard authentication != .noAuthentication else {
            completion(.fail(error: "Rate a TV show needs authentication.".error(domain: "tv")))
            return
        }
        do {
            performRequest(method: "POST",
                           path: "/tv/\(tvShow)/rating",
                           data: try JSONEncoder().encode(["value": rating]),
                           authentication: authentication,
                           expectedStatusCode: 201,
                           completion: completion)
        } catch let error {
            completion(.fail(error: error))
        }
    }
    
    /// Remove your rating for a TV show.
    ///
    /// A valid session or guest session ID is required. You can read more about how this works
    /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    ///
    /// - Parameters:
    ///   - tvShow: TV show's ID.
    ///   - authentication: Authentication type. Accepted `.user` or `.guest`.
    ///   - completion: Completion handler.
    public func removeRating(forTVShow tvShow: Int,
                             authentication: TMDBAuthenticationType,
                             completion: @escaping TMKHandler) {
        guard authentication != .noAuthentication else {
            completion(.fail(error: "Removing rating needs authentication.".error(domain: "tv")))
            return
        }
        performRequest(method: "DELETE",
                       path: "/tv/\(tvShow)/rating",
                       authentication: authentication,
                       completion: completion)
    }
    
    /// Get the most newly created TV show. This is a live response and will continuously change.
    ///
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getLatest(language: String? = nil,
                          completion: @escaping TMKObjectHandler<TMDBTVShowDetailed>) {
        performRequest(path: "/tv/latest",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get a list of TV shows that are airing today. This query is purely day based as we do not
    /// currently support airing times.
    ///
    /// You can specify a timezone to offset the day calculation. Without a specified timezone, this
    /// query defaults to EST (Eastern Time UTC-05:00).
    ///
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getTVAiringToday(language: String? = nil,
                                 page: Int? = nil,
                                 completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        performRequest(path: "/tv/airing_today",
                       query: queryMaker(language: language, page: page),
                       completion: completion)
    }
    
    /// Get a list of shows that are currently on the air.
    ///
    /// This query looks for any TV show that has an episode with an air date in the next 7 days.
    ///
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getTVOnTheAir(language: String? = nil,
                              page: Int? = nil,
                              completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        performRequest(path: "/tv/on_the_air",
                       query: queryMaker(language: language, page: page),
                       completion: completion)
    }
    
    /// Get a list of the current popular TV shows on TMDb. This list updates daily.
    ///
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getPopular(language: String? = nil,
                           page: Int? = nil,
                           completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        performRequest(path: "/tv/popular",
                       query: queryMaker(language: language, page: page),
                       completion: completion)
    }
    
    /// Get a list of the top rated TV shows on TMDb.
    ///
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getTopRated(language: String? = nil,
                            page: Int? = nil,
                            completion: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        performRequest(path: "/tv/top_rated",
                       query: queryMaker(language: language, page: page),
                       completion: completion)
    }
}
