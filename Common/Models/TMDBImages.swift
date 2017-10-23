//
//  Images.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBImage: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let language: String?
    let voteAvrage: Double
    let voteCount: Int
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case language = "iso_639_1"
        case voteAvrage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

public struct TMDBMovieImages: Codable {
    public let id: Int
    public let backdrops: [TMDBImage]
    public let posters: [TMDBImage]
}

public struct TMDBImages: Codable {
    let id: Int
    let backdrops: [TMDBImage]
    let posters: [TMDBImage]
}
