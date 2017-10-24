//
//  TMDBExternalIds.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBExternalIds: Codable {
    public let imdbId: String?
    public let freebaseMid: String?
    public let freebaseId: String?
    public let tvrageId: String?
    public let id: Int
    
    // Movies only.
    public let facebookId: String?
    public let twitterId: String?
    public let instagramId: String?
    
    // TV shows only.
    public let tvdbId: Int?
    
    enum CodingKeys: String, CodingKey {
        case imdbId = "imdb_id"
        case facebookId = "facebook_id"
        case freebaseMid = "freebase_mid"
        case freebaseId = "freebase_id"
        case tvrageId = "tvrage_id"
        case twitterId = "twitter_id"
        case id
        case instagramId = "instagram_id"
        case tvdbId = "tvdb_id"
    }
}
