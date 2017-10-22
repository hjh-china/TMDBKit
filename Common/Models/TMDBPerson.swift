//
//  TMDBPerson.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBPerson: Codable {
    public let adult: Bool
//    public let alsoKnownAs: []
    public let biography: String
    public let birthday: String?
    public let deathday: String?
    public let gender: TMDBPersonGender
    public let homepage: String?
    public let id: Int
    public let imdbId: String?
    public let name: String
    public let placeOfBirth: String?
    public let popularity: Double
    public let profilePath: String?
    
    public enum TMDBPersonGender: Int, Codable {
        case notSet = 0
        case female = 1
        case male = 2
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
//        case alsoKnownAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdbId = "imdb_id"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}
