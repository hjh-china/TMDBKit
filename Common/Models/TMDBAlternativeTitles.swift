//
//  AlternativeTitles.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBAlternativeTitles: Codable {
    public let id: Int
    public let titles: [TMDBAlternativeTitle]
    
    public struct TMDBAlternativeTitle: Codable {
        public let language: String
        public let title: String
        
        enum CodingKeys: String, CodingKey {
            case language = "iso_3166_1"
            case title
        }
    }
}
