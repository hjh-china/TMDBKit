//
//  TMDBManager.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// The TMDB Manager. Takes all the stuff you need to use The Movie Database API v3 in Swift.
public class TMDbManager {
    /// Singleton instance for the `TMDBManager` class.
    public static let shared = TMDbManager()
    
    var apiKey: String?
    var keyChainPrefix: String?
    
    /// Your request token.
    ///
    /// This value will **NOT** be persisted.
    ///
    /// See [The Movie Database API - Authentication](https://developers.themoviedb.org/3/authentication) for more info about request token.
    public var requestToken: String?
    /// The expire time for the request token. Usually 1 hour after you grant a token.
    public var requestTokenExpiresAt: Date?
    
    /// Read-only. The key for session ID persistence in keychain.
    var sessionIdKey: String {
        return keyChainPrefix == nil ? "" : keyChainPrefix! + ".sessionId"
    }
    /// Read-only. The session ID persisted in keychain.
    ///
    /// See [The Movie Database API - Authentication](https://developers.themoviedb.org/3/authentication) for more info about session ID.
    public var sessionID: String? { get { return _sessionId } }
    var _sessionId: String? {
        get {
            if let accessTokenData = KeychainManager.loadData(forKey: sessionIdKey) {
                if let accessTokenString = String.init(data: accessTokenData, encoding: .utf8) {
                    return accessTokenString
                }
            }
            
            return nil
        }
        set {
            if newValue == nil {
                KeychainManager.deleteItem(forKey: sessionIdKey)
            } else {
                let savingSucceeded = KeychainManager.setString(value: newValue!, forKey: sessionIdKey)
                print("SessionID saved successfully:\n\(savingSucceeded)")
            }
        }
    }
    
    /// Your guest session ID.
    ///
    /// This value will **NOT** be persisted.
    ///
    /// See [The Movie Database API - Authentication - Create Guest Session](https://developers.themoviedb.org/3/authentication/create-guest-session) for more info about guest session ID.
    public var guestSessionId: String?
    /// The expire time for the guest session ID.
    public var guestSessionExpiresAt: Date?
}

extension TMDbManager {
    /// Setup the TMDB client.
    ///
    /// - Parameters:
    ///   - apiKey: Your API key, see [TMDB API - Introduction](https://developers.themoviedb.org/3/getting-started) for more info.
    ///   - keyChainPrefix: Prefix for key chain keys. Usually your app's bundle name. For example, you set this value as **com.yourCompanyName.yourAppName**, the session ID will be persisted in keychain for key **com.yourCompanyName.yourAppName.sessionId**.
    public func setupClient(withApiKey apiKey: String, keyChainPrefix: String) {
        self.apiKey = apiKey
        self.keyChainPrefix = keyChainPrefix
    }
    
    /// Check if authrozied, aka if the session ID is nil.
    public var authrozied: Bool {
        return !(_sessionId == nil)
    }
    
    /// Check if Guest Session Id is nil or expired.
    public var guestAzuthrozied: Bool {
        guard
            let _ = guestSessionId,
            let d = guestSessionExpiresAt
            else { return false }
        
        return d <= Date() ? true : false
    }
}

// MARK: - GET methods.
extension TMDbManager {
    /// Perform the GET request with Data returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - path: The relative path for the request, like "/movie/76341".
    ///   - query: Query to be appended.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code, usually 200. Will return an error if the server returns a different code.
    ///   - completion: Completion Handler.
    func performRequest(path: String, query: [String: String] = [:], needAuthentication: Bool = false, expectedStatusCode: Int = 200, completion: @escaping (DataReturn) -> ()) {
        let _request = constructRequest(path: path,
                                       query: query,
                                       needAuthentication: needAuthentication,
                                       expectedStatusCode: expectedStatusCode)
        
        switch _request {
        case .success(let request):
            performRequest(request: request, expectedStatusCode: expectedStatusCode, completion: completion)
        case .fail(let error):
            completion(.fail(error: error))
        }
        
    }
    
    /// Perform the GET request with JSON returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - path: The relative path for the request, like "/movie/76341".
    ///   - query: Query to be appended.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code, usually 200. Will return an error if the server returns a different code.
    ///   - completion: Completion Handler.
    func performRequest(path: String, query: [String: String] = [:], needAuthentication: Bool = false, expectedStatusCode: Int = 200, completion: @escaping (JSONReturn) -> ()) {
        
        performRequest(path: path, query: query, needAuthentication: needAuthentication) { (result: DataReturn) in
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
    
    /// Perform the GET request with Codable object returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - path: The relative path for the request, like "/movie/76341".
    ///   - query: Query to be appended.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code, usually 200. Will return an error if the server returns a different code.
    ///   - completion: Completion Handler.
    func performRequest<T>(path: String, query: [String: String] = [:], needAuthentication: Bool = false, expectedStatusCode: Int = 200, completion: @escaping (ObjectReturn<T>) -> ()) {
        
        performRequest(path: path, query: query, needAuthentication: needAuthentication) { (result: DataReturn) in
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
    
    /// Perform the GET request with a `TMDBPaged` instance returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - path: The relative path for the request, like "/account/12345/rated/tv/episodes".
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///     - minLength: 2
    ///     - pattern: `([a-z]{2})-([A-Z]{2})`
    ///     - default: en-US
    ///   - sortBy: Sort the results. **Allowed Values:** `created_at.asc`, `created_at.desc`
    ///   - page: Specify which page to query.
    ///     - minimum: 1
    ///     - maximum: 1000
    ///     - default: 1
    ///   - completion: Completion Handler.
    func performRequest<T>(path: String, language: String?, sortBy: String?, page: Int?, completion: @escaping (ObjectReturn<TMDbPaged<T>>) -> ()) {
        var query: [String: String] = [:]
        
        if let language = language {
            query["language"] = language
        }
        
        if let sortBy = sortBy {
            query["sort_by"] = sortBy
        }
        
        if let page = page {
            query["page"] = "\(page)"
        }
        performRequest(path: path, query: query, needAuthentication: true, completion: completion)
    }
    
}

// MARK: - POST methods
extension TMDbManager {
    /// Perform the POST request with Data returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - postPath: The relative path for the request, like "/account/1234/watchlist".
    ///   - query: Query to be appended.
    ///   - headers: HTTP request headers.
    ///   - data: HTTP request body.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code, usually 201. Will return an error if the server returns a different code.
    ///   - completion: Completion Handler.
    func performRequest(postPath: String, query: [String: String] = [:], headers: [String: String] = [:], data: Data?, needAuthentication: Bool = true, expectedStatusCode: Int = 201, completion: @escaping (DataReturn) -> ()) {
        let _request = constructRequest(postPath: postPath,
                                       query: query,
                                       headers: headers,
                                       data: data,
                                       needAuthentication: needAuthentication,
                                       expectedStatusCode: expectedStatusCode)
        switch _request {
        case .success(let request):
            performRequest(request: request, expectedStatusCode: expectedStatusCode, completion: completion)
        case .fail(let error):
            completion(.fail(error: error))
        }
    }
    
    /// Perform the POST request with `Codable` object for HTTP request body, and returns data in complition handler closure.
    ///
    /// - Parameters:
    ///   - postPath: The relative path for the request, like "/account/1234/watchlist".
    ///   - query: Query to be appended.
    ///   - headers: HTTP request headers.
    ///   - dataObject: Object that complies to `Codable` protocol. Will be encoded to JSON for HTTP request body.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code, usually 201. Will return an error if the server returns a different code.
    ///   - completion: Completion Handler.
    func performRequest<T: Codable>(postPath: String, query: [String: String] = [:], headers: [String: String] = [:], dataObject: T, needAuthentication: Bool = true, expectedStatusCode: Int = 201, completion: @escaping (NilReturn) -> ()) {
        do {
            let data = try JSONEncoder().encode(dataObject)
            performRequest(postPath: postPath, query: query, headers: headers, data: data, needAuthentication: needAuthentication, expectedStatusCode: expectedStatusCode) { result in
                switch result {
                case .success:
                    completion(.success)
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        } catch let error {
            completion(.fail(error: error))
        }
    }
}

// MARK: - Base request method.
extension TMDbManager {
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
extension TMDbManager {
    /// Construct the basic (GET) URLRequest.
    ///
    /// - Parameters:
    ///   - path: The relative path for the request, like "/movie/76341".
    ///   - query: Query to be appended.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code.
    /// - Returns: An enum carrys the result URLRequest or Error.
    func constructRequest(path: String, query: [String: String] = [:], needAuthentication: Bool = false, expectedStatusCode: Int = 200) -> AnyReturn<URLRequest> {
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
        
        if needAuthentication {
            guard let sessionId = self._sessionId else {
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
        
        return .success(any: URLRequest(url: componmentsUrl))
    }
    
    /// Construct the POST URLRequest.
    ///
    /// - Parameters:
    ///   - postPath: The relative path for the POST request, like "/list/12345/remove_item".
    ///   - query: Query to be appended.
    ///   - headers: POST header.
    ///   - data: Request body.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code.
    /// - Returns: An enum carrys the result URLRequest or Error.
    func constructRequest(postPath path: String, query: [String: String] = [:], headers: [String: String] = [:], data: Data?, needAuthentication: Bool = true, expectedStatusCode: Int = 201) -> AnyReturn<URLRequest> {
        let request: URLRequest!
        let _request = constructRequest(path: path,
                                        query: query,
                                        needAuthentication: needAuthentication,
                                        expectedStatusCode: expectedStatusCode)
        
        switch _request {
        case .success(let _request):
            request = _request
        case .fail(let error):
            return .fail(error: error)
        }
        
        request.httpMethod = "POST"
        if let data = data {
            request.httpBody = data
        }
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if !headers.isEmpty {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return .success(any: request)
    }
    
    /// Construct the DELETE URLRequest.
    ///
    /// - Parameters:
    ///   - deletePath: The relative path for the DELETE request, like "/list/12345/remove_item".
    ///   - query: Query to be appended.
    ///   - headers: POST header.
    ///   - data: Request body.
    ///   - needAuthentication: Whether this request needs appending Seesion ID.
    ///   - expectedStatusCode: Expected status code.
    /// - Returns: An enum carrys the result URLRequest or Error.
    func constructRequest(deletePath path: String, query: [String: String] = [:], needAuthentication: Bool = true, expectedStatusCode: Int = 201) -> AnyReturn<URLRequest> {
        let request: URLRequest!
        let _request = constructRequest(path: path,
                                        query: query,
                                        needAuthentication: needAuthentication,
                                        expectedStatusCode: expectedStatusCode)
        
        switch _request {
        case .success(let _request):
            request = _request
        case .fail(let error):
            return .fail(error: error)
        }
        
        request.httpMethod = "DELETE"
        return .success(any: request)
    }
}
