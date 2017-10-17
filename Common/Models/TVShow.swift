//
//  TVShow.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTVShow: Codable {
    let backdrop_path: String?
    let firstAirDate: Date
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalName: String
    let overview: String
    let originCountry: [String]
    let posterPath: String?
    let popularity: Double
    let name: String
    let voteAverage: Double
    let voteCount: Int
    let rating: Int
}
