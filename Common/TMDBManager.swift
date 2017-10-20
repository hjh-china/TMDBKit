//
//  TMDBManager.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

/// The TMDB Manager. Takes all the stuff you need to use The Movie Database API v3 in Swift.
public class TMDBManager {
    /// Singleton instance for the `TMDBManager` class.
    public static let shared = TMDBManager()
    
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
    
    /// [Account API](https://developers.themoviedb.org/3/account) wrapper instance.
    public let account = AccountAPIWrapper()
    /// [Authentication API](https://developers.themoviedb.org/3/authentication) wrapper instance.
    public let authentication = AuthenticationAPIWrapper()
    /// [Certifications API](https://developers.themoviedb.org/3/certifications) wrapper instance.
    public let certifications = CertificationsAPIWrapper()
    /// [Changes API](https://developers.themoviedb.org/3/changes) wrapper instance.
    public let changes = ChangesAPIWrapper()
    /// [Collections API](https://developers.themoviedb.org/3/collections) wrapper instance.
    public let collections = CollectionsAPIWrapper()
    /// [Companies API](https://developers.themoviedb.org/3/companies) wrapper instance.
    public let companies = CompaniesAPIWrapper()
    /// [Configuration API](https://developers.themoviedb.org/3/configuration) wrapper instance.
    public let configuration = ConfigurationAPIWrapper()
}

extension TMDBManager {
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


