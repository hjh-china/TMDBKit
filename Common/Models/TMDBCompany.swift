//
//  Company.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBCompany: Codable {
    public let description: String?
    public let headquarters: String
    public let homepage: String?
    public let id: Int
    public let logoPath: String?
    public let name: String
    public let parentCompany: TMDBCompanyBasic?
    
    enum CodingKeys: String, CodingKey {
        case description
        case headquarters
        case homepage
        case id
        case logoPath = "logo_path"
        case name
        case parentCompany = "parent_company"
    }
}

public struct TMDBCompanyBasic: Codable {
    let name: String
    let id: Int
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case logoPath = "logo_path"
    }
}
