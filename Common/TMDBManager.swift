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
    
    var requestToken: String?
    var requestTokenExpiresAt: String?
    
    var sessionIdKey: String {
        return keyChainPrefix == nil ? "" : keyChainPrefix! + ".sessionId"
    }
    
    var guestSessionId: String?
    var guestSessionExpiresAt: String?
    
    public var sessionId: String? {
        get {
            if let accessTokenData = MLKeychain.loadData(forKey: sessionIdKey) {
                if let accessTokenString = String.init(data: accessTokenData, encoding: .utf8) {
                    return accessTokenString
                }
            }
            
            return nil
        }
        set {
            if newValue == nil {
                MLKeychain.deleteItem(forKey: sessionIdKey)
            } else {
                let savingSucceeded = MLKeychain.setString(value: newValue!, forKey: sessionIdKey)
                #if DEBUG
                    print("SessionID saved successfully:\n\(savingSucceeded)")
                #endif
            }
        }
    }
}

extension TMDBManager {
    /// Setup the TMDB client
    ///
    /// - Parameters:
    ///   - apiKey: Your API key, see [TMDB API - Introduction](https://developers.themoviedb.org/3/getting-started) for more info.
    ///   - keyChainPrefix: Prefix for key chain keys. For example, you set this value as **com.yourCompanyName.yourAppName**, the session ID will be keyed **com.yourCompanyName.yourAppName.sessionId**.
    public func setupClient(withApiKey apiKey: String, keyChainPrefix: String) {
        self.apiKey = apiKey
        self.keyChainPrefix = keyChainPrefix
    }
    
    /// Check if the user is authrozied. Please note that this computed propety only checks the if the session ID exists and if the session ID is out of expire time. The user may invoke the session ID right through TMDB website.
    public var authrozied: Bool {
        return true
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
    func performRequest(withRelativeUrl relativeUrl: String, query: [String: String] = [:], needAuthentication: Bool, expectedStatusCode: Int = 200, completion: @escaping (DataReturn) -> ()) {
        guard let apiKey = self.apiKey else {
            completion(.fail(error: "API Key is nil, please call setupClient() first.".error()))
            return
        }
        
        guard
            let baseUrl = URL(string: "https://api.themoviedb.org/3/"),
            let url = URL(string: relativeUrl, relativeTo: baseUrl),
            var componments = URLComponents(string: url.absoluteString)
            else {
                completion(.fail(error: "Invalid relative url.".error()))
                return
        }
        
        var queryItems = componments.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        if !query.isEmpty {
            for (key, value) in query {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        componments.queryItems = queryItems
        
        guard
            let componmentsUrl = componments.url
            else { return }
        
        let request = URLRequest(url: componmentsUrl)
        
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
                        message += "Response status code: \(httpResponse.statusCode), yet expecting \(expectedStatusCode)."
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
    
    /// Perform the request with JSON returned in complition handler closure.
    ///
    /// - Parameters:
    ///   - relativeUrl: The relative URL for the request, like "movie/76341".
    ///   - needAuthentication: Whether this request needs authentication.
    ///   - expectedStatusCode: Expected status code, usually 200.
    ///   - completion: Completion Handler.
    func performRequest(withRelativeUrl relativeUrl: String, query: [String: String] = [:], needAuthentication: Bool, expectedStatusCode: Int = 200, completion: @escaping (JSONReturn) -> ()) {
        
        performRequest(withRelativeUrl: relativeUrl, query: query, needAuthentication: needAuthentication) { (result: DataReturn) in
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
    func performRequest<T>(withRelativeUrl relativeUrl: String, query: [String: String] = [:], needAuthentication: Bool, expectedStatusCode: Int = 200, completion: @escaping (ObjectReturn<T>) -> ()) {
        
        performRequest(withRelativeUrl: relativeUrl, query: query, needAuthentication: needAuthentication) { (result: DataReturn) in
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

enum ObjectReturn<T: Codable> {
    case success(object: T)
    case fail(error: Error?)
}

enum DataReturn {
    case success(data: Data)
    case fail(error: Error?)
}

enum JSONReturn {
    case success(json: JSON)
    case fail(error: Error?)
}

