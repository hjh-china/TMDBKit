//
//  GuestSessions.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/21.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [Guest Sessions API](https://developers.themoviedb.org/3/guest-sessions) wrapper class.
public class TMKGuestSessionAPIWrapper: TMKAPIWrapper {
    /// Get the rated movies for a guest session.
    ///
    /// - Parameters:
    ///   - guestSessionId: Pass in a guest session ID to get the rated movies for this guest session.
    /// If set to `nil`, the manager will take persisted guest session ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. Allowed Values: `.createdAtAsc`, `.createdAtDesc`.
    ///   - completin: Completion handler.
    public func getRatedMovies(byGuestSessionId guestSessionId: String? = nil,
                               language: String? = nil,
                               sortBy: TMDBSortOption? = nil,
                               completin: @escaping TMKObjectHandler<TMDBPaged<TMDBMovieGeneral>>) {
        do {
            let gsid = try prepare(guestSessionId: guestSessionId)
            performRequest(path: "/guest_session/\(gsid)/rated/movies",
                           query: queryMaker(language: language, sortBy: sortBy),
                           completion: completin)
        } catch let error {
            completin(.fail(error: error))
        }
    }
    
    /// Get the rated TV shows for a guest session.
    ///
    /// - Parameters:
    ///   - guestSessionId: Pass in a guest session ID to get the rated TV Shows for this guest session.
    /// If set to `nil`, the manager will take persisted guest session ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. Allowed Values: `.createdAtAsc`, `.createdAtDesc`.
    ///   - completin: Completion handler.
    public func getRatedTVShows(byGuestSessionId guestSessionId: String? = nil,
                                language: String? = nil,
                                sortBy: TMDBSortOption? = nil,
                                completin: @escaping TMKObjectHandler<TMDBPaged<TMDBTVShowGeneral>>) {
        do {
            let gsid = try prepare(guestSessionId: guestSessionId)
            performRequest(path: "/guest_session/\(gsid)/rated/tv",
                           query: queryMaker(language: language, sortBy: sortBy),
                           completion: completin)
        } catch let error {
            completin(.fail(error: error))
        }
    }
    
    /// Get the rated TV episodes for a guest session.
    ///
    /// - Parameters:
    ///   - guestSessionId: Pass in a guest session ID to get the rated TV Episodes for this guest session.
    /// If set to `nil`, the manager will take persisted guest session ID.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. Allowed Values: `.createdAtAsc`, `.createdAtDesc`.
    ///   - completin: Completion handler.
    public func getRatedTVEpisodes(byGuestSessionId guestSessionId: String? = nil,
                                   language: String? = nil,
                                   sortBy: TMDBSortOption? = nil,
                                   completin: @escaping TMKObjectHandler<TMDBPaged<TMDBTVEpisodeGeneral>>) {
        do {
            let gsid = try prepare(guestSessionId: guestSessionId)
            performRequest(path: "/guest_session/\(gsid)/rated/tv/episodes",
                           query: queryMaker(language: language, sortBy: sortBy),
                           completion: completin)
        } catch let error {
            completin(.fail(error: error))
        }
    }
    
    /// Prepare guest session ID.
    func prepare(guestSessionId: String?) throws -> String {
        var gsid = ""
        if guestSessionId != nil {
            gsid = guestSessionId!
        } else {
            guard let _gsid = TMDBManager.shared.guestSessionId else {
                throw "No guest session ID is passed as parameter or persisted with UserDefaults.".error(domain: "guestSessions")
            }
            gsid = _gsid
        }
        return gsid
    }
}
