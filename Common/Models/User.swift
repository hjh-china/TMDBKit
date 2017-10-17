//
//  User.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBUser: Codable {
    let avatar: gravatar
    let id: Int
    let language: String
    let region: String
    let name: String
    let includeAdult: Bool
    let username: String
    
    struct gravatar: Codable {
        let hash: String
    }
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case language = "iso_639_1"
        case region = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}
