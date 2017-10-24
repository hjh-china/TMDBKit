//
//  Protocols.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol TMDBJsonInitable {
    init(fromJSON: JSON) throws
}
