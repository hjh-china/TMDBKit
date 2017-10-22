//
//  TMDBTranslations.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBTranslations: Codable {
    public let id: Int
    public let translations: [TMDBTranslation]
    
    public struct TMDBTranslation: Codable {
        public let language: String
        public let region: String
        public let name: String
        public let englishName: String
        
        enum CodingKeys: String, CodingKey {
            case language = "iso_639_1"
            case region = "iso_3166_1"
            case name
            case englishName = "english_name"
        }
    }
}
