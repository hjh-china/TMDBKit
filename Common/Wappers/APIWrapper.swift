//
//  Wrapper.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    public class APIWrapper {
        let manager = TMDBManager.shared
        
        /// Make query dictionary.
        func queryMaker(language: String? = nil,
                        sortBy: TMDBSortOption? = nil,
                        page: Int? = nil,
                        startDate: String? = nil,
                        endDate: String? = nil,
                        country: String? = nil,
                        region: String? = nil,
                        includeAdult: Bool? = nil) -> [String: String] {
            var query: [String: String] = [:]
            
            if let language = language { query["language"] = language }
            if let sortBy = sortBy { query["sort_by"] = sortBy.rawValue }
            if let page = page { query["page"] = "\(page)" }
            if let startDate = startDate { query["start_date"] = startDate }
            if let endDate = endDate { query["end_date"] = endDate }
            if let country = country { query["country"] = country }
            if let region = region { query["region"] = region }
            if let includeAdult = includeAdult { query["include_adult"] = includeAdult ? "true" : "false" }
            
            return query
        }
    }
}
