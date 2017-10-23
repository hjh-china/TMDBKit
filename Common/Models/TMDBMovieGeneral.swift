//
//  Movie.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBMovieGeneral: Codable {
    public let posterPath: String?
    public let adult: Bool
    public let overview: String?
    /// Raw **String** returned from TMDB, usually formatted as `YYYY-MM-dd`. Use `releaseDate` property for **Date**.
    public let rawReleaseDateString: String?
    public let genreIds: [Int]
    public let id: Int
    public let originalTitle: String
    public let originalLanguage: String
    public let title: String
    public let backdropPath: String?
    public let popularity: Double
    public let voteCount: Int
    public let video: Bool
    public let voteAvrage: Double
    /// Only for getRatedMovies()
    public let rating: Int?
    
    public var releaseDate: Date? {
        if let raw = rawReleaseDateString {
            return raw.date(format: "YYYY-MM-dd")
        } else {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case rawReleaseDateString = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAvrage = "vote_average"
        case rating
    }
}
