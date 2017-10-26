//
//  People.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

    /// [People API](https://developers.themoviedb.org/3/people) wrapper class.
/// - TODO: append_to_response support
public class TMKPeopleAPIWrapper: TMKAPIWrapper {
    /// Get the primary person details by id.
    ///
    /// **New as of November 9, 2016:** Biographies are now translatable on TMDb. This means you can
    /// query person details with a language parameter.
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getDetails(forPerson person: Int,
                           language: String? = nil,
                           completion: @escaping TMKObjectHandler<TMDBPersonGeneral>) {
        performRequest(path: "/person/\(person)",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the movie credits for a person.
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getMovieCredits(forPerson person: Int,
                                language: String? = nil,
                                completion: @escaping TMKObjectHandler<TMDBCreditsDetailed>) {
        performRequest(path: "/person/\(person)/movie_credits",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the TV show credits for a person.
    ///
    /// You can query for some extra details about the credit with the
    /// [credit method](https://developers.themoviedb.org/3/credits/get-credit-details).
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getTVCredits(forPerson person: Int,
                             language: String? = nil,
                             completion: @escaping TMKObjectHandler<TMDBCreditsDetailed>) {
        performRequest(path: "/person/\(person)/tv_credits",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the movie and TV credits together in a single response
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getCombinedCredits(forPerson person: Int,
                                   language: String? = nil,
                                   completion: @escaping TMKObjectHandler<TMDBCreditsDetailed>) {
        performRequest(path: "/person/\(person)/combined_credits",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the external ids for a person. We currently support the following external sources.
    ///
    /// **External Sources:**
    /// - IMDB ID
    /// - Facebook
    /// - Freebase MID
    /// - Freebase ID
    /// - Instagram
    /// - TVRage ID
    /// - Twitter
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getExternalIds(forPerson person: Int,
                               language: String? = nil,
                               completion: @escaping TMKObjectHandler<TMDBExternalIds>) {
        performRequest(path: "/person/\(person)/external_ids",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the images for a person.
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - completion: Completion handler.
    public func getImages(forPerson person: Int, completion: @escaping TMKObjectHandler<TMDBImage>) {
        performRequest(path: "/person/\(person)/images", completion: completion)
    }
    
    /// Get the images that this person has been tagged in.
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getTaggedImages(forPerson person: Int,
                                language: String? = nil,
                                page: Int? = nil,
                                completion: @escaping TMKJSONInitableHandler<TMDBTaggedImages>) {
        performRequest(path: "/person/\(person)/tagged_images",
                       query: queryMaker(language: language, page: page),
                       completion: completion)
    }
    
    /// Get the changes for a person. By default only the last 24 hours are returned.
    ///
    /// You can query up to 14 days in a single query by using the start_date and end_date query parameters.
    ///
    /// - Parameters:
    ///   - person: Person's ID.
    ///   - startDate: Filter the results with a start date. Formatted in `YYYY-MM-dd`.
    ///   - endDate: Filter the results with a end date. Formatted in `YYYY-MM-dd`.
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion handler.
    public func getChanges(forPerson person: Int,
                           from startDate: String? = nil,
                           to endDate: String? = nil,
                           page: Int? = nil,
                           completion: @escaping TMKObjectHandler<[TMDBPersonChanges]>) {
        performRequest(
            path: "/movie/\(person)/changes",
            query: queryMaker(startDate: startDate, endDate: endDate, page: page)
        ){ (result: TMKObjectReturn<[String: [TMDBPersonChanges]]>) in
            switch result {
            case .success(let _results):
                if let results = _results["changes"] {
                    completion(.success(object: results))
                } else {
                    completion(.fail(error: "Error get changes for person.".error(domain: "movies")))
                }
            case .fail(let error):
                completion(.fail(error: error))
            }
        }
    }
    
    /// Get the most newly created person. This is a live response and will continuously change.
    ///
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - completion: Completion handler.
    public func getLatest(language: String? = nil,
                          completion: @escaping TMKObjectHandler<TMDBPersonGeneral>) {
        performRequest(path: "/person/latest",
                       query: queryMaker(language: language),
                       completion: completion)
    }
    
    /// Get the list of popular people on TMDb. This list updates daily.
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
                           completion: @escaping TMKJSONInitableHandler<TMDBPersonDetailed>) {
        performRequest(path: "/person/popular",
                       query: queryMaker(language: language, page: page),
                       completion: completion)
    }
}
