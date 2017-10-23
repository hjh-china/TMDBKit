//
//  FindResult.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBFindResult {
    public let movieResults: [TMDBMovieGeneral]
    public let personResults: [TMDBFindPersonResult]
    public let tvResults: [TMDBTVShow]
    public let tvEpisodeResults: [TMDBTVEpisode]
    public let tvSeasonResults: [TMDBTVSeason]
    
    public struct TMDBFindPersonResult {
        public let profilePath: String?
        public let adult: Bool
        public let id: Int
        public let knownForMovies: [TMDBMovieGeneral]
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
            
            var knownForMovies: [TMDBMovieGeneral] = []
            var knownForTVShows: [TMDBTVShow] = []
            
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
    
    init(fromJSON json: JSON) throws {
        let decoder = JSONDecoder()
        
        let movieData = try json["movie_results"].rawData()
        movieResults = try decoder.decode([TMDBMovieGeneral].self, from: movieData)
        let tvData = try json["tv_results"].rawData()
        tvResults = try decoder.decode([TMDBTVShow].self, from: tvData)
        let tvEpisodeData = try json["tv_episode_results"].rawData()
        tvEpisodeResults = try decoder.decode([TMDBTVEpisode].self, from: tvEpisodeData)
        let tvSeasonData = try json["tv_season_results"].rawData()
        tvSeasonResults = try decoder.decode([TMDBTVSeason].self, from: tvSeasonData)
        
        var peopleResults: [TMDBFindPersonResult] = []
        if let people = json["person_results"].array {
            for person in people {
                peopleResults.append(try TMDBFindPersonResult(fromJSON: person))
            }
        }
        self.personResults = peopleResults
    }
}

extension TMDBFindResult.TMDBFindPersonResult: CustomDebugStringConvertible {
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

extension TMDBFindResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        var str = "================================\n"
        str += "TMDBFindResult Debug Description"
        str += "\n================================\n"
        
        str += "0⃣️ Movies [\(movieResults.count) items]: \n"
        if !movieResults.isEmpty {
            for m in 0..<movieResults.count {
                str += """
                👉 No. \(m):
                \(movieResults[m])
                
                """
            }
        }
        
        str += "1⃣️ Persons [\(personResults.count) items]: \n"
        if !personResults.isEmpty {
            for p in 0..<personResults.count {
                str += """
                👉 No. \(p):
                \(personResults[p])
                
                """
            }
        }

        str += "2⃣️ TV Shows [\(tvResults.count) items]: \n"
        if !tvResults.isEmpty {
            for s in 0..<tvResults.count {
                str += """
                👉 No. \(s):
                \(tvResults[s])
                
                """
            }
        }

        str += "3⃣️ TV Seasons [\(tvSeasonResults.count) items]: \n"
        if !tvSeasonResults.isEmpty {
            for s in 0..<tvSeasonResults.count {
                str += """
                👉 No. \(s):
                \(tvSeasonResults[s])
                
                """
            }
        }

        str += "4⃣️ TV Episodes [\(tvEpisodeResults.count) items]: \n"
        if !tvEpisodeResults.isEmpty {
            for e in 0..<tvEpisodeResults.count {
                str += """
                👉 No. \(e):
                \(tvEpisodeResults[e])
                
                """
            }
        }
        str += "\n================================\n"
        
        return str
    }
}
