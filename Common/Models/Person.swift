//
//  Person.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBPerson {
    public let profilePath: String?
    public let adult: Bool
    public let id: Int
    public let knownForMovies: [TMDBMovie]
    public let knownForTVShows: [TMDBTVShow]
    public let name: String
    public let popularity: Double
    
    init(fromJSON json: JSON) throws {
        guard
            let adult = json["adult"].bool,
            let id = json["id"].int,
            let name = json["name"].string,
            let popularity = json["popularity"].double
        else {
            throw "Error init TMDBPerson: one of adult/id/name/popularity is nil.".error(domain: "models.TMDBPerson")
        }
        
        self.profilePath = json["profile_path"].string
        self.adult       = adult
        self.id          = id
        self.name        = name
        self.popularity  = popularity
        
        var knownForMovies: [TMDBMovie] = []
        var knownForTVShows: [TMDBTVShow] = []
        
        if let arr = json["known_for"].array {
            for obj in arr {
                if let type = obj["media_type"].string {
                    switch type {
                    case "movie":
                        do {
                            let data = try obj.rawData()
                            let movie = try JSONDecoder().decode(TMDBMovie.self, from: data)
                            knownForMovies.append(movie)
                        } catch let error {
                            print("Error initing known-for TMDBMovie from JSON for people \(name), but TMDBPeople should continue to init ;-)\n\(error)")
                        }
                    case "tv":
                        do {
                            let data = try obj.rawData()
                            let tvShow = try JSONDecoder().decode(TMDBTVShow.self, from: data)
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
}

extension TMDBPerson: CustomDebugStringConvertible {
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
