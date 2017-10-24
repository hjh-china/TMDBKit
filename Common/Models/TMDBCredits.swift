//
//  TMDBMovieCredit.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBCreditsBasic: Codable {
    public let cast: [TMDBCastBasic]
    public let crew: [TMDBCrewBasic]
    public let id: Int
}

public struct TMDBTVEpisodeCredits: Codable {
    public let airDate: String
    public let crew: [TMDBCrewBasic]
    public let episodeNumber: Int
    public let guestStars: [TMDBCastBasic]
    public let name: String
    public let overview: String
    public let id: Int
    public let productionCode: String
    public let seasonNumber: Int
    public let stillPath: String?
    public let voteAverage: Double
    public let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case crew
        case episodeNumber = "episode_number"
        case guestStars = "guest_stars"
        case name
        case overview
        case id
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public struct TMDBCastBasic: Codable {
    public let id: Int
    public let name: String
    public let creditId: String
    public let department: String
    public let job: String
    public let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case creditId = "credit_id"
        case department
        case job
        case profilePath = "profile_path"
    }
}

public struct TMDBCrewBasic: Codable {
    public let id: Int
    public let name: String
    public let creditId: String
    public let character: String
    public let order: Int
    public let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case creditId = "credit_id"
        case character
        case order
        case profilePath = "profile_path"
    }
}

public struct TMDBCreditsDetailed: Codable {
    public let cast: [TMDMCastDetailed]
    public let crew: [TMDBCrewDetailed]
    public let id: Int
}

public struct TMDMCastDetailed: Codable {
    /// Media type
    public let mediaType: String?
    
    /// Movie only.
    public let releaseDate: String?
    /// Movie only.
    public let video: Bool?
    /// Movie only.
    public let title: String?
    /// Movie only.
    public let adult: Bool?
    /// Movie only.
    public let originalTitle: String?
    
    /// TV only.
    public let originalName: String?
    /// TV only.
    public let name: String?
    /// TV only.
    public let episodeCount: Int?
    /// TV only.
    public let firstAirDate: String?
    /// TV only.
    public let originCountry: [String]?
    
    public let character: String
    public let creditId: String
    public let voteCount: Int
    public let voteAverage: Double
    public let genreIds: [Int]
    public let originalLanguage: String
    public let popularity: Double
    public let id: Int
    public let backdropPath: String?
    public let overview: String
    public let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        
        case releaseDate = "release_date"
        case video
        case title
        case adult
        case originalTitle = "original_title"
        
        case originalName = "original_name"
        case name
        case episodeCount = "episode_count"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        
        case character
        case creditId = "credit_id"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case popularity
        case id
        case backdropPath = "backdrop_path"
        case overview
        case posterPath = "poster_path"
    }
}

public struct TMDBCrewDetailed: Codable {
    /// Media type.
    public let mediaType: String?
    
    /// Movie only.
    public let originalTitle: String?
    /// Movie only.
    public let video: Bool?
    /// Movie only.
    public let title: String?
    /// Movie only.
    public let adult: Bool?
    /// Movie only.
    public let releaseDate: String?
    
    /// TV only.
    public let episodeCount: Int?
    /// TV only.
    public let originalName: String?
    /// TV only.
    public let originCountry: String?
    /// TV only.
    public let name: String?
    /// TV only.
    public let firstAirDate: String?
    
    public let id: Int
    public let department: String
    public let originalLanguage: String
    public let job: String
    public let overview: String
    public let voteCount: Int
    public let posterPath: String?
    public let backdropPath: String?
    public let popularity: Double
    public let genreIds: [Int]
    public let voteAverage: Double
    public let creditId: String
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        
        case originalTitle = "original_title"
        case video
        case title
        case adult
        case releaseDate = "release_date"
        
        case episodeCount = "episode_count"
        case originalName = "original_name"
        case originCountry = "origin_country"
        case name
        case firstAirDate = "first_air_date"
        
        case id
        case department
        case originalLanguage = "original_language"
        case job
        case overview
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case popularity
        case genreIds = "genre_ids"
        case voteAverage = "vote_average"
        case creditId = "credit_id"
    }
}
