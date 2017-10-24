//
//  Networks.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Networks API](https://developers.themoviedb.org/3/networks) wrapper class.
    public class NetworksAPIWrapper: APIWrapper {
        /// Get the details of a network.
        ///
        /// - Parameters:
        ///   - network: Network's ID.
        ///   - completion: Completion handler.
        public func getDetails(forNetwork network: Int,
                               completion: @escaping ObjectHandler<TMDBNetwork>) {
            performRequest(path: "/network/\(network)",
                           completion: completion)
        }
    }
}
