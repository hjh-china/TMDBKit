//
//  TMDBPerson.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct TMDBPersonGeneral: Codable {
    public let adult: Bool
//    public let alsoKnownAs: []
    public let biography: String
    public let birthday: String?
    public let deathday: String?
    public let gender: TMDBGender
    public let homepage: String?
    public let id: Int
    public let imdbId: String?
    public let name: String
    public let placeOfBirth: String?
    public let popularity: Double
    public let profilePath: String?
    
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

public struct TMDBPersonDetailed: TMDBJsonInitable, CustomDebugStringConvertible {
    public let profilePath: String?
    public let adult: Bool
    public let id: Int
    public let knownForMovies: [TMDBMovieGeneral]
    public let knownForTVShows: [TMDBTVShowGeneral]
    public let name: String
    public let popularity: Double
    
    public init(fromJSON json: JSON) throws {
        guard
            let adult = json["adult"].bool,
            let id = json["id"].int,
            let name = json["name"].string,
            let popularity = json["popularity"].double
        else {
            throw "Cannot init TMDBPersonWithKnownForMedia from JSON".error(domain: "models")
        }
        
        self.profilePath = json["profile_path"].string
        self.adult       = adult
        self.id          = id
        self.name        = name
        self.popularity  = popularity
        
        var knownForMovies: [TMDBMovieGeneral] = []
        var knownForTVShows: [TMDBTVShowGeneral] = []
        
        if let arr = json["known_for"].array {
            for obj in arr {
                if let type = obj["media_type"].string {
                    switch type {
                    case "movie":
                        do {
                            let data = try obj.rawData()
                            let movie = try JSONDecoder().decode(TMDBMovieGeneral.self, from: data)
                            knownForMovies.append(movie)
                        } catch let error {
                            print("Error initing known-for TMDBMovie from JSON for people \(name), but TMDBPeople should continue to init ;-)\n\(error)")
                        }
                    case "tv":
                        do {
                            let data = try obj.rawData()
                            let tvShow = try JSONDecoder().decode(TMDBTVShowGeneral.self, from: data)
                            knownForTVShows.append(tvShow)
                        } catch let error {
                            print("Error initing known-for TMDBTVShow from JSON for people \(name), but TMDBPeople should continue to init ;-)\n\(error)")
                        }
                    default:
                        continue
                    }
                }
            }
        }
        
        self.knownForMovies = knownForMovies
        self.knownForTVShows = knownForTVShows
    }
    
    public var debugDescription: String {
        return """
        PEOPLE:       \(name)
        ID:           \(id)
        Adult:        \(adult)
        Popularity:   \(popularity)
        Profile path: \(profilePath ?? "Nil")
        Known for movies [\(knownForMovies.count) items]:
        - \(knownForMovies.map({ m in return m.title }))
        Knwon for shows  [\(knownForTVShows.count) items]:
        - \(knownForTVShows.map({ s in return s.name }))
        """
    }
}
