//
//  TVSeasin.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTVSeasonBasic: Codable {
    public let airDate: String
    public let episodeCount: Int
    public let id: Int
    public let posterPath: String?
    public let seasonNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

public struct TMDBTVSeasonGeneral: Codable {
    public let _id: String?
    public let airDate: String
    public let episodes: [TMDBTVEpisodeGeneral]?
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

public struct TMDBTVSeasonDetailed: Codable {
    public let _id: String?
    public let airDate: String
    public let episodes: [TMDBTVEpisodeDetailed]?
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
