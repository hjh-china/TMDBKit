//
//  Configuration.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [Configuration API](https://developers.themoviedb.org/3/configuration) wrapper class.
public class TMKConfigurationAPIWrapper: TMKAPIWrapper {
    /// Get the system wide configuration information. Some elements of the API require some knowledge
    /// of this configuration data. The purpose of this is to try and keep the actual API responses as
    /// light as possible. It is recommended you cache this data within your application and check for
    /// updates every few days.
    ///
    /// This method currently holds the data relevant to building image URLs as well as the change key map.
    ///
    /// To build an image URL, you will need 3 pieces of data. The `base_url`, `size` and `file_path`.
    /// Simply combine them all and you will have a fully qualified URL. Here’s an example URL:
    /// ```
    /// https://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg
    /// ```
    /// The configuration method also contains the list of change keys which can be useful if you are
    /// building an app that consumes data from the change feed.
    /// - Parameter completion: Completion handler.
    public func getAPIConfiguration(completion: @escaping TMKHandler) {
        performRequest(path: "/configuration") { (result: TMKJSONReturn) in
            switch result {
            case .success(let json):
                if let baseUrl = json["images"]["base_url"].string {
                    TMDBManager.shared.imageBaseUrlString = baseUrl
                } else {
                    print("❌ Fail to get image base url.")
                }
                if let secureImageBaseUrl = json["images"]["secure_base_url"].string {
                    TMDBManager.shared.secureImageBaseUrlString = secureImageBaseUrl
                } else {
                    print("❌ Fail to get secure (aka https) image base url.")
                }
                if let backdropSizes = json["images"]["backdrop_sizes"].arrayObject as? [String] {
                    TMDBManager.shared.avaliableBackdropSizes = TMDBAvaliableSizes(backdropSizes)
                } else {
                    print("❌ Fail to get image backdrop sizes.")
                }
                if let logoSizes = json["images"]["logo_sizes"].arrayObject as? [String] {
                    TMDBManager.shared.avaliableLogoSizes = TMDBAvaliableSizes(logoSizes)
                } else {
                    print("❌ Fail to get image logo sizes.")
                }
                if let posterSizes = json["images"]["poster_sizes"].arrayObject as? [String] {
                    TMDBManager.shared.avaliablePosterSizes = TMDBAvaliableSizes(posterSizes)
                } else {
                    print("❌ Fail to get image poster sizes.")
                }
                if let profileSizes = json["images"]["profile_sizes"].arrayObject as? [String] {
                    TMDBManager.shared.avaliableProfileSizes = TMDBAvaliableSizes(profileSizes)
                } else {
                    print("❌ Fail to get image profile sizes.")
                }
                if let stillSizes = json["images"]["still_sizes"].arrayObject as? [String] {
                    TMDBManager.shared.avaliableStillSizes = TMDBAvaliableSizes(stillSizes)
                } else {
                    print("❌ Fail to get image still sizes.")
                }
                if let changeKeys = json["change_keys"].arrayObject as? [String] {
                    TMDBManager.shared.changeKeys = changeKeys
                } else {
                    print("❌ Fail to get change keys.")
                }
                completion(.success)
            case .fail(let error):
                completion(.fail(data: error.data, error: error.error))
            }
        }
    }
}
