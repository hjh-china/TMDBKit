//
//  TMDBReleaseDates.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBReleaseDates: Codable {
    public let id: String
    public let results: [TMDBReleaseDateResult]
    
    public struct TMDBReleaseDateResult: Codable {
        public let region: String
        public let results: [TMDBReleaseDate]
        
        enum CodingKeys: String, CodingKey {
            case region = "iso_3166_1"
            case results
        }
        
        public struct TMDBReleaseDate: Codable {
            public let certification: String
            public let language: String
            public let note: String
            public let releaseDate: String
            public let type: TMDBReleaseDateType
            
            public enum TMDBReleaseDateType: Int, Codable {
                case premiere = 1
                case theatricalLimited = 2
                case theatrical = 3
                case digital = 4
                case physical = 5
                case tv = 6
            }
            
            enum CodingKeys: String, CodingKey {
                case certification
                case language = "iso_639_1"
                case note
                case releaseDate = "release_date"
                case type
            }
        }
    }
}
