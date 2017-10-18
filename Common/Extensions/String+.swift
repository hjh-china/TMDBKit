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
    
    func error(domain: String) -> Error {
        let userInfo = ["title": "TMDB Kit Error",
                        NSLocalizedDescriptionKey: self,
                        NSLocalizedRecoverySuggestionErrorKey: ""]
        let error = NSError(domain: "im.sr2k.TMDBKit.\(domain)", code: -1, userInfo: userInfo)
        
        return error
    }
    
    func iso8601Date() -> Date? {
        let splited = self.split(separator: " ")
        if splited.count >= 2 {
            return ISO8601DateFormatter().date(from: splited[0] + "T" + splited[1] + "Z")
        } else {
            return nil
        }
    }
    
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
