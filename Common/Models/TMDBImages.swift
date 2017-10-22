//
//  Images.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBMovieImages: Codable {
    public let id: Int
    public let backdrops: [TMDBImage]
    public let posters: [TMDBImage]
}
