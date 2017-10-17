//
//  MediaObject.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBFavoriteMediaObject: Codable {
    let mediaType: MediaType
    let mediaId: Int
    let favorite: Bool
    
    enum MediaType: String, Codable {
        case movie
        case tv
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favorite
    }
}

public struct TMDBWatchlistMediaObject: Codable {
    let mediaType: MediaType
    let mediaId: Int
    let watchlist: Bool
    
    enum MediaType: String, Codable {
        case movie
        case tv
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchlist
    }
}
