//
//  Authentication.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// [Authentication API](https://developers.themoviedb.org/3/authentication) wrapper class.
public class TMKAuthenticationAPIWrapper: TMKAPIWrapper {
    /// Returns the authentication URL.
    ///
    /// - Parameter redirectURL: Where your user will be redirected to after authentication.
    /// - Returns: The authentication URL. Can be nil if `requestToken` is nil.
    public func authenticationURL(redirectURL: URL?) -> URL? {
        guard let requestToken = TMDBManager.shared.requestToken  else { return nil }
        var baseURLString = "https://www.themoviedb.org/authenticate/\(requestToken)"
        if let redirectURL = redirectURL {
            baseURLString += "redirect_to=\(redirectURL)"
        }
        return URL(string: baseURLString)
    }
    
    /// Create a temporary request token that can be used to validate a TMDb user login. More details about
    /// how this works can be found
    /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    public func createRequestToken(completion: @escaping TMKHandler) {
        
        let path = "/authentication/token/new"
        
        performRequest(path: path) { (result: TMKJSONReturn) in
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                    let requestToken = json["request_token"].string,
                    let expiresAt = json["expires_at"].string {
                    if success {
                        TMDBManager.shared.requestToken = requestToken
                        TMDBManager.shared.requestTokenExpiresAt = expiresAt.iso8601Date()
                        completion(.success)
                    } else {
                        let msg = "TMDB returned fail when creating request token."
                        completion(.fail(data: json.data(), error: msg.error(domain: "authentication")))
                    }
                } else {
                    let msg = "JSON data returned from TMDB for creating request token cannot be serialized."
                    completion(.fail(data: json.data(), error: msg.error(domain: "authentication")))
                }
            case .fail(let error):
                completion(.fail(data: error.data, error: error.error))
            }
        }
    }
    
    /// You can use this method to create a fully valid session ID once a user has validated
    /// the request token. More information about how this works can be found
    /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    public func createSession(completion: @escaping TMKHandler) {
        guard let requestToken = TMDBManager.shared.requestToken else {
            let msg = "Request Token is nil, please call createRequestToken(completion:) ahead to create one."
            completion(.fail(data: nil, error: msg.error(domain: "authentication")))
            return
        }
        
        let path = "/authentication/session/new"
        let query = ["request_token": requestToken]
        
        performRequest(path: path, query: query) { (result: TMKJSONReturn) in
            self.sessionIDHelper(result: result, completion: completion)
        }
    }
    
    /// This method allows an application to validate a request token by entering a username and password.
    ///
    /// **Caution:** Please note, using this method is **strongly discouraged**.
    /// The preferred method of validating a request token is to have a user authenticate the request
    /// via the TMDb website. You can read about that method
    /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    /// - Parameters:
    ///   - username: User's username
    ///   - password: User's password
    public func createSessionWithLogin(username: String, password: String, completion: @escaping TMKHandler) {
        guard let requestToken = TMDBManager.shared.requestToken else {
            let msg = "Request Token is nil, please call createRequestToken(completion:) ahead to create one."
            completion(.fail(data: nil, error: msg.error(domain: "authentication")))
            return
        }
        
        let path = "/authentication/token/validate_with_login"
        let query = ["username": username,
                     "password": password,
                     "request_token": requestToken]
        performRequest(path: path, query: query) { (result: TMKJSONReturn) in
            self.sessionIDHelper(result: result, completion: completion)
        }
    }
    
    /// This method will let you create a new guest session. Guest sessions are a type of session that
    /// will let a user rate movies and TV shows but not require them to have a TMDb user account. More
    /// information about user authentication can be found
    /// [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    ///
    /// Please note, you should only generate a single guest session per user (or device) as you will be
    /// able to attach the ratings to a TMDb user account in the future. There is also IP limits in place
    /// so you should always make sure it's the end user doing the guest session actions.
    ///
    /// If a guest session is not used for the first time within 24 hours, it will be automatically deleted.
    public func createGuestSession(completion: @escaping TMKHandler) {
        let path = "/authentication/guest_session/new"
        performRequest(path: path) { (result: TMKJSONReturn) in
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                    let guestSessionId = json["guest_session_id"].string,
                    let expiresAt = json["expires_at"].string {
                    if success {
                        TMDBManager.shared.guestSessionId = guestSessionId
                        TMDBManager.shared.guestSessionExpiresAt = expiresAt.iso8601Date()
                        completion(.success)
                    } else {
                        let msg = "TMDB returned fail when creating guest session."
                        completion(.fail(data: json.data(), error: msg.error(domain: "authentication")))
                    }
                } else {
                    let msg = "JSON data returned from TMDB for creating guest session cannot be serialized."
                    completion(.fail(data: json.data(), error: msg.error(domain: "authentication")))
                }
            case .fail(let error):
                completion(.fail(data: error.data, error: error.error))
            }
        }
    }
}

extension TMKAuthenticationAPIWrapper {
    func sessionIDHelper(result: TMKJSONReturn, completion: @escaping TMKHandler) {
        switch result {
        case .success(let json):
            if let success = json["success"].bool,
                let sessionId = json["session_id"].string {
                if success {
                    TMDBManager.shared.sessionId = sessionId
                    completion(.success)
                } else {
                    let msg = "TMDB returned fail when creating session with login."
                    completion(.fail(data: json.data(), error: msg.error(domain: "authentication")))
                }
            } else {
                let msg = "JSON data returned from TMDB for creating session with login cannot be serialized."
                completion(.fail(data: json.data(), error: msg.error(domain: "authentication")))
            }
        case .fail(let error):
            completion(.fail(data: error.data, error: error.error))
        }
    }
}
