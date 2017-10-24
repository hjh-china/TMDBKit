//
//  FindResult.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBFindResult: TMDBJsonInitable {
    public let movieResults: [TMDBMovieGeneral]
    public let personResults: [TMDBPersonDetailed]
    public let tvResults: [TMDBTVShowGeneral]
    public let tvEpisodeResults: [TMDBTVEpisodeBasic]
    public let tvSeasonResults: [TMDBTVSeasonGeneral]
    
    public init(fromJSON json: JSON) throws {
        let decoder = JSONDecoder()
        
        let movieData = try json["movie_results"].rawData()
        movieResults = try decoder.decode([TMDBMovieGeneral].self, from: movieData)
        let tvData = try json["tv_results"].rawData()
        tvResults = try decoder.decode([TMDBTVShowGeneral].self, from: tvData)
        let tvEpisodeData = try json["tv_episode_results"].rawData()
        tvEpisodeResults = try decoder.decode([TMDBTVEpisodeBasic].self, from: tvEpisodeData)
        let tvSeasonData = try json["tv_season_results"].rawData()
        tvSeasonResults = try decoder.decode([TMDBTVSeasonGeneral].self, from: tvSeasonData)
        
        var peopleResults: [TMDBPersonDetailed] = []
        if let people = json["person_results"].array {
            for person in people {
                peopleResults.append(try TMDBPersonDetailed(fromJSON: person))
            }
        }
        self.personResults = peopleResults
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
