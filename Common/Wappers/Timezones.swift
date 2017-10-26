//
//  Timezones.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [Timezones API](https://developers.themoviedb.org/3/timezones) wrapper class.
public class TMKTimezonesAPIWrapper: TMKAPIWrapper {
    /// Get the list of supported timezones on TMDb.
    ///
    /// Returned dictonary in completion hanlder is `[CountryCode: [Timezone]]`.
    /// - Parameter completion: Completion handler.
    public func getList(completion: @escaping TMKObjectHandler<[String: [String]]>) {
        performRequest(path: "/timezones/list", completion: completion)
    }
}
