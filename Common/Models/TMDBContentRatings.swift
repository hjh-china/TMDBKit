//
//  TMDBContentRatings.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBContentRatings: Codable {
    public let results: [TMDBContentRating]
    public let id: Int
}

public struct TMDBContentRating: Codable {
    public let country: String
    public let rating: String
    
    enum CodingKeys: String, CodingKey {
        case country = "iso_3166_1"
        case rating
    }
}
