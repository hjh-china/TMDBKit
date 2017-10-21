//
//  SharedRequests.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

// MARK: - GET methods.
extension TMDBManager {
    /// Perform the request with Data returned in complition handler closure.
    func performRequest(method: String = "GET",
                        path: String,
                        query: [String: String] = [:],
                        headers: [String: String] = [:],
                        data: Data? = nil,
                        authentication: AuthenticationType = .noAuthentication,
                        expectedStatusCode: Int = 200,
                        completion: @escaping (DataReturn) -> ()) {
        let _request = constructRequest(method: method,
                                        path: path,
                                        query: query,
                                        headers: headers,
                                        data: data,
                                        authentication: authentication,
                                        expectedStatusCode: expectedStatusCode)
        
        switch _request {
        case .success(let request):
            performRequest(request: request, expectedStatusCode: expectedStatusCode, completion: completion)
        case .fail(let error):
            completion(.fail(error: error))
        }
        
    }
    
    /// Perform the request with JSON returned in complition handler closure.
    func performRequest(method: String = "GET",
                        path: String,
                        query: [String: String] = [:],
                        headers: [String: String] = [:],
                        data: Data? = nil,
                        authentication: AuthenticationType = .noAuthentication,
                        expectedStatusCode: Int = 200,
                        completion: @escaping (JSONReturn) -> ()) {
        performRequest(method: method,
                       path: path,
                       query: query,
                       headers: headers,
                       data: data,
                       authentication: authentication,
                       expectedStatusCode: expectedStatusCode) { (result: DataReturn) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    completion(.success(json: json))
                } catch let error {
                    completion(.fail(error: error))
                }
            case .fail(let error):
                completion(.fail(error: error))
            }
        }
    }
    
    /// Perform the request with Codable object returned in complition handler closure.
    func performRequest<T>(method: String = "GET",
                           path: String,
                           query: [String: String] = [:],
                           headers: [String: String] = [:],
                           data: Data? = nil,
                           authentication: AuthenticationType = .noAuthentication,
                           expectedStatusCode: Int = 200,
                           completion: @escaping (ObjectReturn<T>) -> ()) {
        performRequest(method: method,
                       path: path,
                       query: query,
                       headers: headers,
                       data: data,
                       authentication: authentication,
                       expectedStatusCode: expectedStatusCode) { (result: DataReturn) in
            switch result {
            case .success(let data):
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object: object))
                } catch let error {
                    completion(.fail(error: error))
                }
            case .fail(let error):
                completion(.fail(error: error))
            }
        }
    }
    
    /// Perform the request with nothing returned in complition handler closure.
    func performRequest(method: String = "GET",
                        path: String,
                        query: [String: String] = [:],
                        headers: [String: String] = [:],
                        data: Data? = nil,
                        authentication: AuthenticationType = .noAuthentication,
                        expectedStatusCode: Int = 200,
                        completion: @escaping (NilReturn) -> ()) {
        performRequest(method: method,
                       path: path,
                       query: query,
                       headers: headers,
                       data: data,
                       authentication: authentication,
                       expectedStatusCode: expectedStatusCode) { (result: DataReturn) in
            switch result {
            case .success:
                completion(.success)
            case .fail(let error):
                completion(.fail(error: error))
            }
        }
    }
}

// MARK: - Base request method.
extension TMDBManager {
    /// Base method for performming request.
    ///
    /// - Parameters:
    ///   - request: URLRequest that needs to be performmed.
    ///   - expectedStatusCode: Expected status code. Will return an error if the server returns a different code.
    ///   - completion: Completion handler with `DataReturn` enum.
    func performRequest(request: URLRequest, expectedStatusCode: Int, completion: @escaping (DataReturn) -> ()) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                completion(.fail(error: error))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == expectedStatusCode
                else {
                    var message = ""
                    if data == nil {
                        message += "Data returned from server is nil."
                    } else if response == nil {
                        message += "HTTPResponse is nil."
                    } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != expectedStatusCode {
                        message += "Response status code: \(httpResponse.statusCode), yet expecting \(expectedStatusCode). TMDB returned: \(String(describing: String(data: data!, encoding: .utf8)))"
                    } else {
                        completion(.fail(error: nil))
                        return
                    }
                    completion(.fail(error: message.error()))
                    return
            }
            
            completion(.success(data: responseData))
        })
        
        dataTask.resume()
    }
}

// MARK: - Request constructers.
extension TMDBManager {
    /// Construct URLRequest.
    ///
    /// - Parameters:
    ///   - method: HTTP request method.
    ///   - path: The relative path for the request, like "/movie/76341".
    ///   - query: Query to be appended.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code.
    /// - Returns: An enum carrys the result URLRequest or Error.
    func constructRequest(method: String,
                          path: String,
                          query: [String: String],
                          headers: [String: String],
                          data: Data?,
                          authentication: AuthenticationType,
                          expectedStatusCode: Int) -> AnyReturn<URLRequest> {
        // Check API Key
        guard let apiKey = self.apiKey else {
            return .fail(error: "API Key is nil, please call setupClient(withApiKey:keyChainPrefix:) first.".error())
        }
        
        // Construct URLComponments
        guard
            let baseUrl = URL(string: "https://api.themoviedb.org/3"),
            var componments = URLComponents(string: baseUrl.absoluteString)
            else {
                return .fail(error: "Invalid path.".error())
        }
        componments.path += path
        
        // Append query items
        var queryItems = componments.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        switch authentication {
        case .noAuthentication:
            break
        case .guest:
            guard guestAzuthrozied else {
                return .fail(error: "Guest session ID is nil or expired, please grant authentication first.".error())
            }
            queryItems.append(URLQueryItem(name: "guest_session_id", value: guestSessionId))
        case .user:
            guard let sessionId = self.sessionId else {
                return .fail(error: "Session ID is nil, please grant authentication first.".error())
            }
            queryItems.append(URLQueryItem(name: "session_id", value: sessionId))
        }
        
        if !query.isEmpty {
            for (key, value) in query {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        componments.queryItems = queryItems
        
        // Construct request
        guard let componmentsUrl = componments.url else {
            return .fail(error: "Fail constructing URLComponments".error())
        }
        var request = URLRequest(url: componmentsUrl)
        
        // Set up headers and body
        if method != "GET" {
            request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        request.httpMethod = method
        for (headerField, value) in headers {
            request.addValue(value, forHTTPHeaderField: headerField)
        }
        
        request.httpBody = data
        
        return .success(any: request)
    }
    
    /// Make query dictionary.
    func queryMaker(language: String? = nil,
                    sortBy: TMDBSortOption? = nil,
                    page: Int? = nil,
                    includeAdult: Bool? = nil) -> [String: String] {
        var query: [String: String] = [:]
        
        if let language = language { query["language"] = language }
        if let sortBy = sortBy { query["sort_by"] = sortBy.rawValue }
        if let page = page { query["page"] = "\(page)" }
        if let includeAdult = includeAdult { query["include_adult"] = includeAdult ? "true" : "false" }
        
        return query
    }
}

extension TMDBManager {
    public enum AuthenticationType {
        case user
        case guest
        case noAuthentication
    }
}

