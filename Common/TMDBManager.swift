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
    var persistencePrefix: String?
    
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
        return persistencePrefix == nil ? "" : persistencePrefix! + ".sessionId"
    }
    /// Read-only. The session ID persisted in keychain.
    ///
    /// See [The Movie Database API - Authentication](https://developers.themoviedb.org/3/authentication) for more info about session ID.
    internal(set) public var sessionId: String? {
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
    internal(set) public var guestSessionId: String?
    /// The expire time for the guest session ID.
    internal(set) public var guestSessionExpiresAt: Date?
    
    /// Image base URL.
    internal(set) public var imageBaseUrlString: String? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).imageBaseUrlString") as? String
        }
        
        set {
            if let persistencePrefix = persistencePrefix {
                UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).imageBaseUrlString")
            }
        }
    }
    
    /// Image base URL with HTTPS.
    internal(set) public var secureImageBaseUrlString: String? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).secureImageBaseUrlString") as? String
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).secureImageBaseUrlString")
        }
    }
    
    /// Change keys.
    internal(set) public var changeKeys: [String] {
        get {
            if let persistencePrefix = persistencePrefix, let changeKeys = UserDefaults.standard.object(forKey: "\(persistencePrefix).changeKeys") as? [String] {
                return changeKeys
            } else {
                return []
            }
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).changeKeys")
        }
    }
    
    /// Avaliable widths for backdrops. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableBackdropHeights` property and "original" size avaliable.
    public lazy var avaliableBackdropWidths: [Int] = {
        guard let sizes = backdropSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "w") })
    }()
    
    /// Avaliable heights for backdrops. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableBackdropWidths` property and "original" size avaliable.
    public lazy var avaliableBackdropHeights: [Int] = {
        guard let sizes = backdropSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "h") })
    }()
    
    var backdropSizes: [String]? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).backdropSizes") as? [String]
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).backdropSizes")
        }
    }
    
    /// Avaliable widths for logos. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableLogoHeights` property and "original" size avaliable.
    public lazy var avaliableLogoWidths: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "w") })
    }()
    
    /// Avaliable heights for logos. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableLogoWidths` property and "original" size avaliable.
    public lazy var avaliableLogoHeights: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "h") })
    }()
    
    var logoSizes: [String]? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).logoSizes") as? [String]
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).logoSizes")
        }
    }
    
    /// Avaliable widths for posters. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliablePosterHeights` property and "original" size avaliable.
    public lazy var avaliablePosterWidths: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "w") })
    }()
    
    /// Avaliable heights for posters. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliablePosterWidths` property and "original" size avaliable.
    public lazy var avaliablePosterHeights: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "h") })
    }()
    
    var posterSizes: [String]? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).posterSizes") as? [String]
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).posterSizes")
        }
    }
    
    /// Avaliable widths for profile. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableProfileHeights` property and "original" size avaliable.
    public lazy var avaliableProfileWidths: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "w") })
    }()
    
    /// Avaliable heights for profile. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableProfileWidths` property and "original" size avaliable.
    public lazy var avaliableProfileHeights: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "h") })
    }()
    
    var profileSizes: [String]? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).profileSizes") as? [String]
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).profileSizes")
        }
    }
    
    /// Avaliable widths for stills. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableStillHeights` property and "original" size avaliable.
    public lazy var avaliableStillWidths: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "w") })
    }()
    
    /// Avaliable heights for stills. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `avaliableStillWidths` property and "original" size avaliable.
    public lazy var avaliableStillHeights: [Int] = {
        guard let sizes = logoSizes else { return [] }
        return sizes.flatMap({ s in s.sizeFormatted(wOrH: "h") })
    }()
    
    var stillSizes: [String]? {
        get {
            return persistencePrefix == nil ? nil : UserDefaults.standard.object(forKey: "\(persistencePrefix!).stillSizes") as? [String]
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).stillSizes")
        }
    }
    
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
    /// [Credits API](https://developers.themoviedb.org/3/credits) wrapper instance.
    public let credits = CreditsAPIWrapper()
    /// [Discover API](https://developers.themoviedb.org/3/discover) wrapper instance.
    public let discover = DiscoverAPIWrapper()
    /// [Find API](https://developers.themoviedb.org/3/find) wrapper instance.
    public let find = FindAPIWrapper()
}

extension TMDBManager {
    /// Setup the TMDB client.
    ///
    /// - Parameters:
    ///   - apiKey: Your API key, see [TMDB API - Introduction](https://developers.themoviedb.org/3/getting-started) for more info.
    ///   - persistencePrefix: Prefix for persistence keys. Usually your app's bundle name. For example, you set this value as **com.yourCompanyName.yourAppName**, this value is used as:
    ///     - the session ID will be persisted in keychain for key</br>
    ///     **com.yourCompanyName.yourAppName.sessionId**.
    ///     - avaliable logo sizes will be persisted with `UserDefaults` for key</br>
    ///     **com.yourCompanyName.yourAppName.logoSizes**
    public func setupClient(withApiKey apiKey: String, persistencePrefix: String) {
        self.apiKey = apiKey
        self.persistencePrefix = persistencePrefix
    }
    
    /// Check if authrozied, aka if the session ID is nil.
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


