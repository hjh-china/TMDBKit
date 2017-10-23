//
//  SortBy.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/21.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public enum TMDBSortOption: String {
    case createdAtAsc = "created_at.asc"
    case createdAtDesc = "created_at.desc"
}

public enum TMDBAuthenticationType {
    case user
    case guest
    case noAuthentication
}
