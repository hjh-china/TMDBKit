//
//  Job.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBJob: Codable {
    public let department: String
    public let jobList: [String]
    
    enum CodingKeys: String, CodingKey {
        case department
        case jobList = "job_list"
    }
}
