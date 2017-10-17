//
//  TMDBManager.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public class TMDBManager {
    public static let shared = TMDBManager()
    
    var apiKey: String?
    var keyChainPrefix: String?
    
    public var requestToken: String?
    public var requestTokenExpiresAt: Date?
    
    var sessionIdKey: String {
        return keyChainPrefix == nil ? "" : keyChainPrefix! + ".sessionId"
    }
    
    public var sessionId: String? {
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
    
    public var guestSessionId: String?
    public var guestSessionExpiresAt: Date?
}

extension TMDBManager {
    /// Setup the TMDB client.
    ///
    /// - Parameters:
    ///   - apiKey: Your API key, see [TMDB API - Introduction](https://developers.themoviedb.org/3/getting-started) for more info.
    ///   - keyChainPrefix: Prefix for key chain keys. Usually your app's bundle name. For example, you set this value as **com.yourCompanyName.yourAppName**, the session ID will be stored in key chain for key **com.yourCompanyName.yourAppName.sessionId**.
    public func setupClient(withApiKey apiKey: String, keyChainPrefix: String) {
        self.apiKey = apiKey
        self.keyChainPrefix = keyChainPrefix
    }
    
    /// Check if the session ID is nil.
    public var authrozied: Bool {
        return !(sessionId == nil)
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

extension TMDBManager {
    /// Perform the request with Data returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - relativeUrl: The relative URL for the request, like "movie/76341".
    ///   - needAuthentication: Whether this request needs authentication.
    ///   - expectedStatusCode: Expected status code, usually 200.
    ///   - completion: Completion Handler.
    func performRequest(path: String, query: [String: String] = [:], needAuthentication: Bool = false, expectedStatusCode: Int = 200, completion: @escaping (DataReturn) -> ()) {
        // Check API Key
        guard let apiKey = self.apiKey else {
            completion(.fail(error: "API Key is nil, please call setupClient(withApiKey:keyChainPrefix:) first.".error()))
            return
        }
        
        // Construct URLComponments
        guard
            let baseUrl = URL(string: "https://api.themoviedb.org/3"),
            var componments = URLComponents(string: baseUrl.absoluteString)
            else {
                completion(.fail(error: "Invalid path.".error()))
                return
        }
        componments.path += path
        
        // Append query items
        var queryItems = componments.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        if needAuthentication {
            guard let sessionId = self.sessionId else {
                completion(.fail(error: "Session ID is nil, please grant authentication first.".error()))
                return
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
        guard
            let componmentsUrl = componments.url
            else { return }
        
        let request = URLRequest(url: componmentsUrl)
        
        // Construct data task
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
        
        // Resume task
        dataTask.resume()
    }
    
    /// Perform the request with JSON returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - relativeUrl: The relative URL for the request, like "movie/76341".
    ///   - needAuthentication: Whether this request needs authentication.
    ///   - expectedStatusCode: Expected status code, usually 200.
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
    
    /// Perform the request with Codable object returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - relativeUrl: The relative URL for the request, like "movie/76341".
    ///   - needAuthentication: Whether this request needs authentication.
    ///   - expectedStatusCode: Expected status code, usually 200.
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
}
