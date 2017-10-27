//
//  Codable.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/27.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension Encodable {
    func data() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
