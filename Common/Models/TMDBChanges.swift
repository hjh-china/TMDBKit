//
//  Change.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBChanges: Codable {
    public let key: String
    public let items: [TMDBChange]
    
    public struct TMDBChange: Codable {
        public let id: String
        public let action: String
        public let time: String
        public let language: String
        public let value: String
        public let originalValue: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case action
            case time
            case language = "iso_639_1"
            case value
            case originalValue = "original_value"
        }
    }
}
