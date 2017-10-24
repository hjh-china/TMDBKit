//
//  TMDBTVShowDetailed.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTVShowGeneral: Codable {
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

public struct TMDBTVShowDetailed: Codable {
    public let backdropPath: String?
    public let createdBy: TMDBCreatedBy
    public let episodeRunTime: [Int]
    public let firstAirDate: String?
    public let genres: [TMDBGenre]
    public let homepage: String
    public let id: Int
    public let inProduction: Bool
    public let languages: [String]
    public let lastAirDate: String?
    public let name: String
    public let networks: [TMDBNetwork]
    public let numberOfEpisodes: Int
    public let numberOfSeasons: Int
    public let originCountry: [String]
    public let originalLanguage: [String]
    public let originalName: [String]
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let productionCompanies: [TMDBCompanyBasic]
    public let seasons: [TMDBTVSeasonBasic]
    public let status: String
    public let type: String
    public let voteAverage: Double
    public let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case homepage
        case id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case name
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case seasons
        case status
        case type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
