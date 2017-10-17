//
//  String+.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension String {
    func error() -> Error {
        let userInfo = ["title": "TMDB Kit Error",
                        NSLocalizedDescriptionKey: self,
                        NSLocalizedRecoverySuggestionErrorKey: ""]
        let error = NSError(domain: "im.sr2k.TMDBKit", code: -1, userInfo: userInfo)
        
        return error
    }
}
