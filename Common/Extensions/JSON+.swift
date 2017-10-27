//
//  JSON+.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/27.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    func data() -> Data? {
        do {
            return try self.rawData()
        } catch {
            return nil
        }
    }
}
