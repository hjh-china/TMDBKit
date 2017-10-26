//
//  SortBy.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/21.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias TMKObjectHandler<T: Codable> = (TMKObjectReturn<T>) -> Void
public typealias TMKJSONInitableHandler<T: TMDBJsonInitable> = (TMKJSONInitableReturn<T>) -> Void
public typealias TMKJSONHandler = (TMKJSONReturn) -> Void
public typealias TMKHandler = (TMKReturn) -> Void
public typealias TMKAnyHandler<T> = (TMKAnyReturn<T>) -> Void

public enum TMDBSortOption: String {
    case createdAtAsc = "created_at.asc"
    case createdAtDesc = "created_at.desc"
}

public enum TMDBAuthenticationType {
    case user
    case guest
    case noAuthentication
}

/// Returns a TMDBKit object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns a TMDBKit object.
/// - fail: Request failed, and returns an Error.
public enum TMKObjectReturn<T: Codable> {
    case success(object: T)
    case fail(error: Error?)
}

/// Returns a TMDBKit object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns a TMDBKit object.
/// - fail: Request failed, and returns an Error.
public enum TMKJSONInitableReturn<T: TMDBJsonInitable> {
    case success(object: T)
    case fail(error: Error?)
}

/// Returns raw data or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns raw data from the server.
/// - fail: Request failed, and returns an Error.
public enum TMKDataReturn {
    case success(data: Data)
    case fail(error: Error?)
}

public typealias DataHandler = (TMKDataReturn) -> Void

/// Returns a JSON object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns a JSON object.
/// - fail: Request failed, and returns an Error.
public enum TMKJSONReturn {
    case success(json: JSON)
    case fail(error: Error?)
}

/// Returns nothing when succeed or an Error when failed in a completion handler closure.
///
/// - success: Request was successfully fullfiled.
/// - fail: Request failed, and returns an Error.
public enum TMKReturn {
    case success
    case fail(error: Error?)
}

/// Returns any type of object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns an object.
/// - fail: Request failed, and returns an Error.
public enum TMKAnyReturn<T> {
    case success(any: T)
    case fail(error: Error?)
}
