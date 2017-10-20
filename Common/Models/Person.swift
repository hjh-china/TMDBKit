//
//  Person.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBPerson: Codable {
    public let profilePath: String
    public let adult: Bool
    public let id: Int
    public let knownForMovie: TMDBMovie?
    public let knownForTVShow: TMDBTVShow?
    public let name: String
    public let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case profilePath = ""
        case adult
        case id
        case knownForMovie = "known_for"
        case knownForTVShow// = "known_for"
        case name
        case popularity
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try container.decode(String.self, forKey: CodingKeys.title)
        profilePath = try container.decode(String.self, forKey: .profilePath)
        adult = try container.decode(Bool.self, forKey: .adult)
        id = try container.decode(Int.self, forKey: .id)
        knownForMovie = try container.decodeIfPresent(TMDBMovie.self, forKey: .knownForMovie)
        knownForTVShow = try container.decodeIfPresent(TMDBTVShow.self, forKey: .knownForMovie)
        name = try container.decode(String.self, forKey: .name)
        popularity = try container.decode(Double.self, forKey: .popularity)
    }
}
