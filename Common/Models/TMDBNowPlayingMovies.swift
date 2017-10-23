//
//  TMDBNowPlaying.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBNowPlayingMovies: Codable {
    public let page: Int
    public let results: [TMDBMovieGeneral]
    public let totalPages: Int
    public let totalResults: Int
    public let dates: TMDBNowPlayingDates
    
    public struct TMDBNowPlayingDates: Codable {
        public let maximum: String
        public let minimum: String
    }
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case dates
    }
}
