//
//  TMDBReview.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBReview: Codable {
    public let id: String
    public let author: String
    public let content: String
    public let url: String
}
