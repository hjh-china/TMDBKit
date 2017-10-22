//
//  TVEpisodes.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTVEpisode: Codable {
    public let _id: String?
    /// Raw **String** returned from TMDB, usually formatted as `yyyy-MM-dd`. Use `airDate` property for **Date**.
    public let rawAirDateString: String?
    public let episodeNumber: Int
    public let name: String
    public let id: Int
    public let seasonNumber: Int
    public let stillPath: String?
    public let showId: Int
    public let voteAverage: Double
    public let voteCount: Int
    /// Only fot getRatedTVEpisodes()
    public let rating: Int?
    
    public var airDate: Date? {
        if let raw = rawAirDateString {
            return raw.date(format: "yyyy-MM-dd")
        } else {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case _id
        case rawAirDateString = "air_date"
        case episodeNumber = "episode_number"
        case name
        case id
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case showId = "show_id"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case rating
    }
}
