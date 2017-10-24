//
//  TMDBScreenedTheatricallyShows.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/25.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBScreenedTheatricallyShows: Codable {
    public let id: Int
    public let results: [TMDBScreenedTheatricallyShow]
}

public struct TMDBScreenedTheatricallyShow: Codable {
    public let id: Int
    public let episodeNumber: Int
    public let seasonNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case episodeNumber = "episode_number"
        case seasonNumber = "season_number"
    }
}
