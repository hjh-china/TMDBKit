//
//  Genre.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/21.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBGenre: Codable {
    public let id: Int
    public let name: String
}

public struct TMDBGenres: Codable {
    public let genres: [TMDBGenre]
}
