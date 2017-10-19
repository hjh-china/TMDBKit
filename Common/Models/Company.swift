//
//  Company.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBCompany: Codable {
    let description: String?
    let headquarters: String
    let homepage: String?
    let id: Int
    let logoPath: String?
    let name: String
    let parentCompany: ParentCompany?
    
    enum CodingKeys: String, CodingKey {
        case description
        case headquarters
        case homepage
        case id
        case logoPath = "logo_path"
        case name
        case parentCompany = "parent_company"
    }
    
    struct ParentCompany: Codable {
        let name: String
        let id: Int
        let logoPath: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case id
            case logoPath = "logo_path"
        }
    }
}
