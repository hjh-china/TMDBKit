//
//  Lists.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Lists API](https://developers.themoviedb.org/3/lists) wrapper class.
    /// # v4 or v3 lists?
    /// You may have noticed that the a v4 version of our list API exists. While these v3 list methods continue to work, all of the new features you can see on our website are only available if you switch to the v4 lists.
    ///
    /// **What are some of the improvements in v4?**
    /// - You can import "unlimited" items in a single request
    /// - You can use mixed type (movie and TV) lists
    /// - You can use private lists
    /// - You can add and use comments per item
    /// - There are more sort options
    /// - They are faster
    ///
    /// Check the [v4 documentation](https://developers.themoviedb.org/4/list) for more information.
    public class ListsAPIWrapper: APIWrapper {
        /// Get the details of a list.
        ///
        /// - Parameters:
        ///   - list: List's ID.
        ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
        ///     - minLength: 2
        ///     - pattern: ([a-z]{2})-([A-Z]{2})
        ///     - default: en-US
        ///   - completion: Completion handler.
        public func getDetails(forList list: Int, language: String?, completion: @escaping (ObjectReturn<TMDBList>) -> ()) {
            performRequest(path: "/list/\(list)",
                           query: queryMaker(language: language),
                           completion: completion)
        }
        
        /// You can use this method to check if a movie has already been added to the list.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - list: List's ID.
        ///   - completion: Completion handler.
        public func checkItemStatus(whetherMovie movie: Int, isInList list: Int, completion: @escaping (ObjectReturn<TMDBItemStatus>) -> ()) {
            performRequest(path: "/list/\(list)/item_status",
                           query: ["movie_id": "\(movie)"],
                           completion: completion)
        }
        
        /// Create List.
        ///
        /// - Parameters:
        ///   - name: List's name.
        ///   - description: List's description.
        ///   - language: List's language.
        ///   - completion: Completion handler, carrys ID of the list that just created, or an Error if failed.
        public func createList(named name: String, description: String, language: String, completion: @escaping (AnyReturn<Int>) -> ()) {
            let list = ["name": name,
                        "description": description,
                        "language": language]
            performRequest(method: "POST",
                           path: "/list",
                           data: try! JSONEncoder().encode(list),
                           authentication: .user,
                           expectedStatusCode: 201) { (result: JSONReturn) in
                switch result {
                case .success(let json):
                    guard
                        let success = json["success"].bool,
                        success == true,
                        let listId = json["list_id"].int
                    else {
                        completion(.fail(error: "Error creating list.".error(domain: "lists")))
                        return
                    }
                    completion(.success(any: listId))
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
        
        /// Add a movie to a list.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - list: List's ID
        ///   - completion: Completion handler.
        public func add(movie: Int, toList list: Int, completion: @escaping (NilReturn) -> ()) {
            performRequest(method: "POST",
                           path: "/list/\(list)/add_item",
                           data: try! JSONEncoder().encode(["media_id": movie]),
                           authentication: .user,
                           expectedStatusCode: 201,
                           completion: completion)
        }
        
        /// Remove a movie from a list.
        ///
        /// - Parameters:
        ///   - movie: Movie's ID.
        ///   - list: List's ID.
        ///   - completion: Completion handler.
        public func remove(movie: Int, fromList list: Int, completion: @escaping (NilReturn) -> ()) {
            performRequest(method: "POST",
                           path: "/list/\(list)/remove_item",
                           data: try! JSONEncoder().encode(["media_id": movie]),
                           authentication: .user,
                           expectedStatusCode: 201,
                           completion: completion)
        }
        
        /// Clear all of the items from a list.
        ///
        /// - Parameters:
        ///   - list: List's ID.
        ///   - completion: Completion handler.
        public func clear(list: Int, completion: @escaping (NilReturn) -> ()) {
            performRequest(method: "POST",
                           path: "/list/\(list)/remove_item",
                           query: ["confirm": "true"],
                           authentication: .user,
                           expectedStatusCode: 201,
                           completion: completion)
        }
        
        /// Delete List
        ///
        /// - Parameters:
        ///   - list: List's ID.
        ///   - completion: Completion handler.
        public func delete(list: Int, completion: @escaping (NilReturn) -> ()) {
            performRequest(method: "DELETE",
                           path: "/list/\(list)/add_item",
                           authentication: .user,
                           expectedStatusCode: 201,
                           completion: completion)
        }
    }
}
