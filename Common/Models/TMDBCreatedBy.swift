//
//  TMDBCreatedBy.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBCreatedBy: Codable {
    public let id: Int
    public let name: String
    public let gender: TMDBGender
    public let profilePath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case profilePath = "profile_path"
    }
}
