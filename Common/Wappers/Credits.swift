//
//  Credits.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Credits API](https://developers.themoviedb.org/3/credits) wrapper class.
    public class CreditsAPIWrapper: APIWrapper {
        /// Get a movie or TV credit details by id.
        /// TODO: What's credit???? I wish I have take English class more seriously😂.
        /// - Parameters:
        ///   - creditId: Credit's id.
        ///   - completiomn: Completion handler.
        public func getDetails(forCredit creditId: Int, completiomn: @escaping (JSONReturn) -> ()) {
            manager.performRequest(path: "/credit/\(creditId)", completion: completiomn)
        }
    }
}
