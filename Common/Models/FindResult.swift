//
//  FindResult.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBFindResult: Codable {
    public let movieResults: [TMDBMovie]
    public let personResults: [TMDBPerson]
    public let tvResults: [TMDBTVShow]
    public let tvEpisodeResults: [TMDBTVEpisode]
    public let tvSeasonResults: [TMDBTVSeason]
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
        case personResults = "person_results"
        case tvResults = "tv_results"
        case tvEpisodeResults = "tv_episode_results"
        case tvSeasonResults = "tv_season_results"
    }
}
