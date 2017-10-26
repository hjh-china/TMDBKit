//
//  User.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBUser: Codable {
    public let avatar: Avatar
    public let id: Int
    public let language: String
    public let region: String
    public let name: String
    public let includeAdult: Bool
    public let username: String
    
    /// Returns the user's Gravatar URL
    public func gravatarUrl(size: Int?) -> URL? {
        guard let hash = self.avatar.gravatar.hash else {
            return nil
        }
        var path = "https://www.gravatar.com/avatar/\(hash)"
        if let size = size {
            path += "&size = \(size)"
        }
        return URL(string: path)
    }
    
    public struct Avatar: Codable {
        public let gravatar: Gravatar
        
        public struct Gravatar: Codable {
            let hash: String?
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case language = "iso_639_1"
        case region = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}
