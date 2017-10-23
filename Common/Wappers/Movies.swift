//
//  Movies.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Movies API](https://developers.themoviedb.org/3/movies) wrapper class.
    /// - TODO:
    ///   - Credits
    ///   - append_to_response support
    public class MoviesAPIWrapper: APIWrapper {
        /// Get the primary information about a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getDetails(forMovie movie: Int,
                               language: String? = nil,
                               completion: @escaping (ObjectReturn<TMDBMovieDetailed>) -> Void) {
            performRequest(path: "/movie/\(movie)",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Grab the following account states for a session:
        ///
        /// - Movie rating
        /// - If it belongs to your watchlist
        /// - If it belongs to your favourite list
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - authentication: Authentication type. **Accepted values:** `.user`, `.guest`.
        ///   - completion: Completion handler.
        public func getAccountStates(forMovie movie: Int,
                                     authentication: TMDBAuthenticationType,
                                     completion: @escaping (JSONInitableReturn<TMDBAccountStete>) -> Void) {
            guard authentication != .noAuthentication else {
                completion(.fail(error: "Get account states needs authentication.".error(domain: "movies")))
                return
            }
            performRequest(path: "/movie/\(movie)/account_states",
                           authentication: authentication,
                           completion: completion)
        }
        
        /// Get all of the alternative titles for a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - country: Country code.
        ///   - completion: Completion hanlder.
        public func getAlternativeTitles(forMovie movie: Int,
                                         country: String? = nil,
                                         completion: @escaping (ObjectReturn<TMDBAlternativeTitles>) -> Void) {
            performRequest(path: "/movie/\(movie)/alternative_titles",
                           query: queryMaker(country: country),
                           completion: completion)
        }
        
        /// Get the changes for a movie. By default only the last 24 hours are returned.
        ///
        /// You can query up to 14 days in a single query by using the `startDate` and `endDate` query parameters.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
        ///   - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getChanges(forMovie movie: Int,
                               from startDate: String? = nil,
                               to endDate: String? = nil,
                               page: Int? = nil, completion: @escaping (ObjectReturn<[TMDBChanges]>) -> Void) {
            performRequest(path: "/movie/\(movie)/changes",
                           query: queryMaker(startDate: startDate,
                                             endDate: endDate,
                                             page: page)) { (result: ObjectReturn<[String: [TMDBChanges]]>) in
                switch result {
                case .success(let _results):
                    if let results = _results["changes"] {
                        completion(.success(object: results))
                    } else {
                        completion(.fail(error: "Error get changes for movie.".error(domain: "movies")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }

        /// Get the cast and crew for a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - completion: Completion handler.
        public func getCredits(forMovie movie: Int, completion: @escaping (JSONReturn) -> Void) {
            performRequest(path: "/movie/\(movie)/credits",
                           completion: completion)
        }

        /// Get the images that belong to a movie.
        ///
        /// Querying images with a `language` parameter will filter the results.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - includeImageLanguage: If you want to include a fallback language (especially useful for
        /// backdrops) you can use the `includeImageLanguage` parameter. This should be a comma seperated
        /// value like so:
        ///     ```
        ///     let includeImageLanguage = "en,null"
        ///     ```
        ///   - completion: Completion handler.
        public func getImages(forMovie movie: Int,
                              language: String? = nil,
                              includeImageLanguage: String? = nil,
                              completion: @escaping (ObjectReturn<TMDBMovieImages>) -> Void) {
            var query = queryMaker(language: language)
            if let includeImageLanguage = includeImageLanguage {
                query["include_image_language"] = includeImageLanguage
            }
            performRequest(path: "/movie/\(movie)/images",
                           query: query,
                           completion: completion)
        }
        
        /// Get the keywords that have been added to a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - completion: Completion handler.
        public func getKeywords(forMovie movie: Int, completion: @escaping (ObjectReturn<TMDBKeywords>) -> Void) {
            performRequest(path: "movie/\(movie)/keywords",
                           completion: completion)
        }
        
        /// Get the release date along with the certification for a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - completion: Completion handler.
        public func getReleaseDates(forMovie movie: Int,
                                    completion: @escaping (ObjectReturn<TMDBReleaseDates>) -> Void) {
            performRequest(path: "/movie/\(movie)/release_dates",
                           completion: completion)
        }
        
        /// Get the videos that have been added to a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getVideos(forMovie movie: Int,
                              language: String? = nil,
                              completion: @escaping (ObjectReturn<TMDBVideos>) -> Void) {
            performRequest(path: "/movie/{movie_id}/videos",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Get a list of translations that have been created for a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - completion: Completion handler.
        public func getTranslations(forMovie movie: Int,
                                    completion: @escaping (ObjectReturn<TMDBTranslations>) -> Void) {
            performRequest(path: "/movie/\(movie)/translations", completion: completion)
        }
        
        /// Get a list of recommended movies for a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getRecommendations(forMovie movie: Int,
                                       language: String? = nil,
                                       page: Int? = nil,
                                       completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovieGeneral>>) -> Void) {
            performRequest(path: "/movie/\(movie)/recommendations",
                           query: queryMaker(language: language, page: page),
                           completion: completion)
        }
        
        /// Get a list of similar movies. This is **not** the same as the "Recommendation" system you see
        /// on the website.
        ///
        /// These items are assembled by looking at keywords and genres.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getSimilarMovies(forMovie movie: Int,
                                     language: String? = nil,
                                     page: Int? = nil,
                                     completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovieGeneral>>) -> Void) {
            performRequest(path: "/movie/\(movie)/similar",
                           query: queryMaker(language: language, page: page),
                           completion: completion)
        }
        
        /// Get the user reviews for a movie.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getReviews(forMovie movie: Int,
                               language: String? = nil,
                               page: Int? = nil,
                               completion: @escaping (ObjectReturn<TMDBPaged<TMDBReview>>) -> Void) {
            performRequest(path: "/movie/\(movie)/reviews",
                           query: queryMaker(language: language, page: page),
                           completion: completion)
        }
        
        /// Get a list of lists that this movie belongs to.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - page: Specify which page to query.
        ///     - minimum: 1
        ///     - maximum: 1000
        ///     - default: 1
        ///   - completion: Completion handler.
        public func getLists(forMovie movie: Int,
                             language: String? = nil,
                             page: Int? = nil,
                             completion: @escaping (ObjectReturn<TMDBPaged<TMDBList>>) -> Void) {
            performRequest(path: "/movie/\(movie)/lists",
                           query: queryMaker(language: language, page: page),
                           completion: completion)
        }
        
        /// Rate a movie.
        ///
        /// A valid session or guest session ID is required. You can read more about how this works
        /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - rating: This is the value of the rating you want to submit. The value is expected to be
        /// between 0.5 and 10.0.
        ///     - minimum: 0.5
        ///     - maximum: 10
        ///   - authentication: Authentication type. Accepted `.user` or `.guest`.
        ///   - completion: Completion handler.
        public func rate(movie: Int,
                         rating: Double,
                         authentication: TMDBAuthenticationType,
                         completion: @escaping (NilReturn) -> Void) {
            do {
                performRequest(method: "POST",
                               path: "/movie/\(movie)/rating",
                               data: try JSONEncoder().encode(["value": rating]),
                               expectedStatusCode: 201,
                               completion: completion)
            } catch let error {
                completion(.fail(error: error))
            }
        }
        
        /// Remove your rating for a movie.
        ///
        /// A valid session or guest session ID is required. You can read more about how this works
        /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - authentication: Authentication type. Accepted `.user` or `.guest`.
        ///   - completion: Completion handler.
        public func removeRating(forMovie movie: Int,
                                 authentication: TMDBAuthenticationType,
                                 completion: @escaping (NilReturn) -> Void) {
            performRequest(method: "DELETE",
                           path: "/movie/\(movie)/rating",
                           completion: completion)
        }
        
        /// Get the most newly created movie. This is a live response and will continuously change.
        ///
        /// - Parameters:
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: `([a-z]{2})-([A-Z]{2})`
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getLatest(language: String? = nil,
                              completion: @escaping (ObjectReturn<TMDBMovieDetailed>) -> Void) {
            performRequest(path: "/movie/latest",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// Get a list of movies in theatres. This is a release type query that looks for all movies
        /// that have a release type of 2 or 3 within the specified date range.
        ///
        /// You can optionally specify a `region` prameter which will narrow the search to only look for
        /// theatrical release dates within the specified country.
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
        ///   - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
        ///     - pattern: `^[A-Z]{2}$`
        ///   - completion: Completion handler.
        public func getNowPlaying(language: String? = nil,
                                  page: Int? = nil,
                                  region: String? = nil,
                                  completion: @escaping (ObjectReturn<TMDBNowPlayingMovies>) -> Void) {
            performRequest(path: "/movie/now_playing",
                           query: queryMaker(language: language, page: page, region: region),
                           completion: completion)
        }
        
        /// Get a list of the current popular movies on TMDb. This list updates daily.
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
        ///   - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
        ///     - pattern: `^[A-Z]{2}$`
        ///   - completion: Completion handler.
        public func getPopular(language: String? = nil,
                               page: Int? = nil,
                               region: String? = nil,
                               completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovieGeneral>>) -> Void) {
            performRequest(path: "/movie/popular",
                           query: queryMaker(language: language, page: page, region: region),
                           completion: completion)
        }
        
        /// Get the top rated movies on TMDb.
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
        ///   - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
        ///     - pattern: `^[A-Z]{2}$`
        ///   - completion: Completion handler.
        public func getTopRated(language: String? = nil,
                                page: Int? = nil,
                                region: String? = nil,
                                completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovieGeneral>>) -> Void) {
            performRequest(path: "/movie/top_rated",
                           query: queryMaker(language: language, page: page, region: region),
                           completion: completion)
        }
        
        /// Get a list of upcoming movies in theatres. This is a release type query that looks for all movies
        /// that have a release type of 2 or 3 within the specified date range.
        ///
        /// You can optionally specify a `region` prameter which will narrow the search to only look for
        /// theatrical release dates within the specified country.
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
        ///   - region: Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
        ///     - pattern: `^[A-Z]{2}$`
        ///   - completion: Completion handler.
        public func getUpcoming(language: String? = nil,
                                page: Int? = nil,
                                region: String? = nil,
                                completion: @escaping (ObjectReturn<TMDBPaged<TMDBMovieGeneral>>) -> Void) {
            performRequest(path: "/movie/upcoming",
                           query: queryMaker(language: language, page: page, region: region),
                           completion: completion)
        }
    }
}
