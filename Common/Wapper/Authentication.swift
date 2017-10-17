//
//  Authentication.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {    
    /// Create a temporary request token that can be used to validate a TMDb user login. More details about how this works can be found [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    public func createRequestToken() {
        
        let relativeUrlString = "/authentication/token/new"
        
        performRequest(withRelativeUrl: relativeUrlString, needAuthentication: false) { (result: JSONReturn) in
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                    let requestToken = json["request_token"].string,
                    let expiresAt = json["expires_at"].string,
                    success {
                    self.requestToken = requestToken
                    self.requestTokenExpiresAt = expiresAt
                }
            case .fail(let error):
                #if debug
                    print("Error Creating Request Token: \(error)")
                #endif
            }
        }
    }
    
    /// You can use this method to create a fully valid session ID once a user has validated the request token. More information about how this works can be found [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    public func createSession() {
        guard let requestToken = self.requestToken else {
            #if debug
                print("Request Token is nil, please call createRequestToken() ahead to create one.")
            #endif
            return
        }
        
        let relativeUrlString = "/authentication/session/new"
        let query = ["request_token": requestToken]
        
        performRequest(withRelativeUrl: relativeUrlString, query: query, needAuthentication: false) { (result: JSONReturn) in
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                    let sessionId = json["session_id"].string,
                    success {
                    self.sessionId = sessionId
                }
            case .fail(let error):
                #if debug
                    print("Error Creating Session: \(error)")
                #endif
            }
        }
    }
    
    /// This method allows an application to validate a request token by entering a username and password.
    ///
    /// **Caution:** Please note, using this method is **strongly discouraged**. The preferred method of validating a request token is to have a user authenticate the request via the TMDb website. You can read about that method [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    /// - Parameters:
    ///   - username: User's username
    ///   - password: User's password
    public func createSessionWithLogin(username: String, password: String) {
        guard let requestToken = self.requestToken else {
            #if debug
                print("Request Token is nil, please call createRequestToken() ahead to create one.")
            #endif
            return
        }
        
        let relativeUrlString = "/authentication/token/validate_with_login"
        let query = ["username": username,
                     "password": password,
                     "request_token": requestToken]
        performRequest(withRelativeUrl: relativeUrlString, query: query, needAuthentication: false) { (result: JSONReturn) in
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                    let sessionId = json["session_id"].string,
                    success {
                    self.sessionId = sessionId
                }
            case .fail(let error):
                #if debug
                    print("Error Creating Session: \(error)")
                #endif
            }
        }
    }
    
    /// This method will let you create a new guest session. Guest sessions are a type of session that will let a user rate movies and TV shows but not require them to have a TMDb user account. More information about user authentication can be found [here](https://developers.themoviedb.org/3/authentication/how-do-i-generate-a-session-id).
    ///
    /// Please note, you should only generate a single guest session per user (or device) as you will be able to attach the ratings to a TMDb user account in the future. There is also IP limits in place so you should always make sure it's the end user doing the guest session actions.
    ///
    /// If a guest session is not used for the first time within 24 hours, it will be automatically deleted.
    public func createGuestSession() {
        let relativeUrlString = "/authentication/guest_session/new"
        performRequest(withRelativeUrl: relativeUrlString, needAuthentication: false) { (result: JSONReturn) in
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                    let guestSessionId = json["guest_session_id"].string,
                    let expiresAt = json["expires_at"].string,
                    success {
                    self.guestSessionId = guestSessionId
                    self.guestSessionExpiresAt = expiresAt
                }
            case .fail(let error):
                #if debug
                    print("Error Creating Session: \(error)")
                #endif
            }
        }
    }
}
