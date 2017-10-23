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

/// Returns a TMDBKit object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns a TMDBKit object.
/// - fail: Request failed, and returns an Error.
public enum ObjectReturn<T: Codable> {
    case success(object: T)
    case fail(error: Error?)
}

/// Returns a TMDBKit object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns a TMDBKit object.
/// - fail: Request failed, and returns an Error.
public enum JSONInitableReturn<T: TMDBJsonInitable> {
    case success(object: T)
    case fail(error: Error?)
}

/// Returns raw data or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns raw data from the server.
/// - fail: Request failed, and returns an Error.
public enum DataReturn {
    case success(data: Data)
    case fail(error: Error?)
}

/// Returns a JSON object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns a JSON object.
/// - fail: Request failed, and returns an Error.
public enum JSONReturn {
    case success(json: JSON)
    case fail(error: Error?)
}

/// Returns nothing when succeed or an Error when failed in a completion handler closure.
///
/// - success: Request was successfully fullfiled.
/// - fail: Request failed, and returns an Error.
public enum NilReturn {
    case success
    case fail(error: Error?)
}

/// Returns any type of object or an Error in a completion handler closure.
///
/// - success: Request was successfully fullfiled, and returns an object.
/// - fail: Request failed, and returns an Error.
public enum AnyReturn<T> {
    case success(any: T)
    case fail(error: Error?)
}
