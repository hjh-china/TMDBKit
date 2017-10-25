//
//  Wrapper.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation
import SwiftyJSON

extension TMDBManager {
    public class APIWrapper {        
        /// Perform the request with Data returned in complition handler closure.
        func performRequest(method: String = "GET",
                            path: String,
                            query: [String: String] = [:],
                            headers: [String: String] = [:],
                            data: Data? = nil,
                            authentication: TMDBAuthenticationType = .noAuthentication,
                            expectedStatusCode: Int = 200,
                            completion: @escaping DataHandler) {
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
                            authentication: TMDBAuthenticationType = .noAuthentication,
                            expectedStatusCode: Int = 200,
                            completion: @escaping JSONHandler) {
            performRequest(method: method,
                           path: path,
                           query: query,
                           headers: headers,
                           data: data,
                           authentication: authentication,
                           expectedStatusCode: expectedStatusCode) { (result: DataReturn) in
                switch result {
                case .success(let data):
                    let json = JSON(data: data)
                    completion(.success(json: json))
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
                               authentication: TMDBAuthenticationType = .noAuthentication,
                               expectedStatusCode: Int = 200,
                               completion: @escaping ObjectHandler<T>) {
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
        
        /// Perform the request with object that needs manual initialization from JSON
        /// returned in complition handler closure.
        func performRequest<T>(method: String = "GET",
                               path: String,
                               query: [String: String] = [:],
                               headers: [String: String] = [:],
                               data: Data? = nil,
                               authentication: TMDBAuthenticationType = .noAuthentication,
                               expectedStatusCode: Int = 200,
                               completion: @escaping JSONInitableHandler<T>) {
            performRequest(method: method,
                           path: path,
                           query: query,
                           headers: headers,
                           data: data,
                           authentication: authentication,
                           expectedStatusCode: expectedStatusCode) { (result: JSONReturn) in
                switch result {
                case .success(let json):
                    do {
                        completion(.success(object: try T(fromJSON: json)))
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
                            authentication: TMDBAuthenticationType = .noAuthentication,
                            expectedStatusCode: Int = 200,
                            completion: @escaping Handler) {
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
    
    // MARK: - Base request method.

        /// Base method for performming request.
        ///
        /// - Parameters:
        ///   - request: URLRequest that needs to be performmed.
        ///   - expectedStatusCode: Expected status code. Will return an error if the server returns a different code.
        ///   - completion: Completion handler with `DataReturn` enum.
        func performRequest(request: URLRequest, expectedStatusCode: Int, completion: @escaping DataHandler) {
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
                        } else if
                            let httpResponse = response as? HTTPURLResponse,
                            httpResponse.statusCode != expectedStatusCode {
                            message += "Response status code: \(httpResponse.statusCode), "
                                + "yet expecting \(expectedStatusCode). "
                                + "TMDB returned: \(String(describing: String(data: data!, encoding: .utf8)))"
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

        // MARK: - Request constructers.

        /// Construct URLRequest.
        func constructRequest(method: String,
                              path: String,
                              query: [String: String],
                              headers: [String: String],
                              data: Data?,
                              authentication: TMDBAuthenticationType,
                              expectedStatusCode: Int) -> AnyReturn<URLRequest> {
            // Check API Key
            guard let apiKey = TMDBManager.shared.apiKey else {
                return .fail(error: "API Key is nil, call setupClient(withApiKey:keyChainPrefix:) first plz.".error())
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
                guard TMDBManager.shared.guestAzuthrozied else {
                    return .fail(error: "Guest session ID is nil or expired, grant authentication first plz.".error())
                }
                queryItems.append(URLQueryItem(name: "guest_session_id", value: TMDBManager.shared.guestSessionId))
            case .user:
                guard let sessionId = TMDBManager.shared.sessionId else {
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
        
        /// Make the "query" dictionary.
        func queryMaker(language: String? = nil,
                        sortBy: TMDBSortOption? = nil,
                        startDate: String? = nil,
                        endDate: String? = nil,
                        page: Int? = nil,
                        country: String? = nil,
                        region: String? = nil,
                        query: String? = nil,
                        includeAdult: Bool? = nil) -> [String: String] {
            var _query: [String: String] = [:]
            
            if let language = language   { _query["language"] = language }
            if let sortBy = sortBy       { _query["sort_by"] = sortBy.rawValue }
            if let startDate = startDate { _query["start_date"] = startDate }
            if let endDate = endDate     { _query["end_date"] = endDate }
            if let page = page           { _query["page"] = "\(page)" }
            if let country = country     { _query["country"] = country }
            if let region = region       { _query["region"] = region }
            if let query = query         { _query["query"] = query }
            if let includeAdult = includeAdult { _query["include_adult"] = includeAdult ? "true" : "false" }
            
            return _query
        }
    }

}
