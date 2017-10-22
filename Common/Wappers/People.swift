//
//  People.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [People API](https://developers.themoviedb.org/3/people) wrapper class.
    public class PeopleAPIWrapper: APIWrapper {
        public func getDetails(forPerson person: Int, language: String? = nil, completion: @escaping (ObjectReturn<TMDBPerson>) -> ()) {
            manager.performRequest(path: "/person/\(person)",
                                   query: queryMaker(language: language),
                                   completion: completion)
        }
    }
}
