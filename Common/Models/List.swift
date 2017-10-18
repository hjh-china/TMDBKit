//
//  List.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBList: Codable {
    let description: String
    let favoriteCount: Int
    let id: Int
    let itemCount: Int
    let language: String
    let listType: String
    let name: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case favoriteCount = "favorite_count"
        case id
        case itemCount = "item_count"
        case language = "iso_639_1"
        case listType = "list_type"
        case name
        case posterPath = "poster_path"
    }
}
