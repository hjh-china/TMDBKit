//
//  TMDBMovieCredit.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBCredits: Codable {
    public let cast: [TMDMCast]
    public let crew: [TMDBCrew]
    public let id: Int
    
    public struct TMDMCast: Codable {
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
    
    public struct TMDBCrew: Codable {
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
}
