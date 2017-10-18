//
//  MediaObject.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBFavoriteMediaObject: Codable {
    public let mediaType: MediaType
    public let mediaId: Int
    public let favorite: Bool
    
    /// Init a TMDBFavoriteMediaObject instance.
    ///
    /// - Parameters:
    ///   - mediaType: Movie or TV.
    ///   - mediaId: Media ID.
    ///   - favorite: If `true`, this item will be added to the favotites. If `false`, this item will be removed.
    public init(mediaType: MediaType, mediaId: Int, favorite: Bool) {
        self.mediaType = mediaType
        self.mediaId = mediaId
        self.favorite = favorite
    }
    
    public enum MediaType: String, Codable {
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
    public let mediaType: MediaType
    public let mediaId: Int
    public let watchlist: Bool
    
    /// Init a TMDBWatchlistMediaObject instance.
    ///
    /// - Parameters:
    ///   - mediaType: Movie or TV.
    ///   - mediaId: Media ID.
    ///   - watchlist: If `true`, this item will be added to the watchlist. If `false`, this item will be removed.
    public init(mediaType: MediaType, mediaId: Int, watchlist: Bool) {
        self.mediaType = mediaType
        self.mediaId = mediaId
        self.watchlist = watchlist
    }
    
    public enum MediaType: String, Codable {
        case movie
        case tv
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchlist
    }
}
