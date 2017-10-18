//
//  ReturnTypes.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/18.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public enum ObjectReturn<T: Codable> {
    case success(object: T)
    case fail(error: Error?)
}

public enum DataReturn {
    case success(data: Data)
    case fail(error: Error?)
}

public enum JSONReturn {
    case success(json: JSON)
    case fail(error: Error?)
}

public enum NilReturn {
    case success
    case fail(error: Error?)
}

public enum AnyReturn<T> {
    case success(any: T)
    case fail(error: Error?)
}
