//
//  MovieDetailed.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBMovieDetailed: Codable {
    public let adult: Bool
    public let backdropPath: String?
    public let belongsToCollection: TMDBCollection?
    public let budget: Int
    public let genres: [TMDBGenre]
    public let homepage: String?
    public let id: Int
    public let imdbId: String?
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String?
    public let popularity: Double
    public let posterPath: String?
    public let productionCompanies: [TMDBCompany]
    public let productionCountries: [TMDBCountry]
    public let releaseDate: String?
    public let revenue: Int
    public let runtime: Int?
    public let spokenLanguages: [TMDBLanguage]
    public let status: String
    public let tagline: String?
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    public struct TMDBCountry: Codable {
        public let countryCode: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "iso_3166_1"
            case name
        }
    }
    
    public struct TMDBLanguage: Codable {
        public let languageCode: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case languageCode = "iso_639_1"
            case name
        }
    }
}
