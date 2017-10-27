//
//  Data+.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/27.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension Data {
    public func toString(_ encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
}
