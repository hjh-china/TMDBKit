//
//  TMDBKeywords.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBKeywords: Codable {
    public let id: String
    public let keywords: [TMDBKeyword]
}

public struct TMDBKeyword: Codable {
    public let id: Int
    public let name: String
}
