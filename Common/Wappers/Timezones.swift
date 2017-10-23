//
//  Timezones.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Search API](https://developers.themoviedb.org/3/search) wrapper class.
    /// - TODO: Multi search.
    public class SearchAPIWrapper: APIWrapper {
        /// Get the list of supported timezones on TMDb.
        ///
        /// Returned dictonary in completion hanlder is `[CountryCode: [Timezone]]`.
        /// - Parameter completion: Completion handler.
        public func getList(completion: @escaping (ObjectReturn<[String: [String]]>) -> ()) {
            performRequest(path: "/timezones/list", completion: completion)
        }
    }
}
