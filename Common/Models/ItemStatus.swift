//
//  ItemStatus.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBItemStatus: Codable {
    public let id: String
    public let itemPresent: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemPresent = "item_present"
    }
}
