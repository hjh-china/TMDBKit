//
//  TVSeasin.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTVSeason: Codable {
    public let _id: String?
    public let airDate: String
    public let episodes: [TMDBTVEpisode]?
    public let name: String
    public let overview: String
    public let id: Int
    public let posterPath: String?
    public let seasonNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case _id
        case airDate = "air_date"
        case episodes
        case name
        case overview
        case id
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}
