//
//  TMDBVideos.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBVideos: Codable {
    public let id: Int
    public let results: [TMDBVideo]
    
    public struct TMDBVideo: Codable {
        public let id: String
        public let language: String
        public let country: String
        public let key: String
        public let name: String
        public let site: String
        public let size: Int
        public let type: TMDBVideoType
        
        public enum TMDBVideoType: String, Codable {
            case trailer = "Trailer"
            case teaser = "Teaser"
            case clip = "Clip"
            case featurette = "Featurette"
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case language = "iso_639_1"
            case country = "iso_3166_1"
            case key
            case name
            case site
            case size
            case type
        }
    }
}
