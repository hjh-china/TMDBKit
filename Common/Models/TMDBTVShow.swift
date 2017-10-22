//
//  TVShow.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTVShow: Codable {
    public let backdropPath: String?
    /// Raw **String** returned from TMDB, usually formatted as `YYYY-MM-dd`. Use `firstAirDate` property for **Date**.
    public let rawFirstAirDateString: String?
    public let genreIds: [Int]
    public let id: Int
    public let originalLanguage: String
    public let originalName: String
    public let overview: String?
    public let originCountry: [String]
    public let posterPath: String?
    public let popularity: Double
    public let name: String
    public let voteAverage: Double
    public let voteCount: Int
    /// Only for getRatedTVShows()
    public let rating: Int?
    
    public var firstAirDate: Date? {
        if let raw = rawFirstAirDateString {
            return raw.date(format: "YYYY-MM-dd")
        } else {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity
        case id
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case overview
        case rawFirstAirDateString = "first_air_date"
        case originCountry = "origin_country"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case rating
    }
}
