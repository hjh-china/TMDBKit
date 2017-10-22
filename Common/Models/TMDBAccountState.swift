//
//  TMDBAccountState.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBAccountStete {
    public let id: Int
    public let favorite: Bool
    public let rated: Bool
    public let rating: Int?
    public let watchlist: Bool
    
    init?(fromJSON json: JSON) {
        guard
            let id = json["id"].int,
            let favorite = json["rated"].bool,
            let watchlist = json["watchlist"].bool
        else {
            return nil
        }
        
        self.id = id
        self.favorite = favorite
        self.watchlist = watchlist
        
        if let rating = json["rated"]["value"].int {
            self.rated = true
            self.rating = rating
        } else {
            self.rated = false
            self.rating = nil
        }
    }
}
