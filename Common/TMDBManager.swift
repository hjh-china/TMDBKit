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
    
    /// Your request token. This value will **NOT** be persisted.
    ///
    /// See [this](https://developers.themoviedb.org/3/authentication) for more
    /// info about request token.
    public var requestToken: String?
    /// The expire time for the request token. Usually 1 hour after you grant a token.
    public var requestTokenExpiresAt: Date?
    
    /// Read-only. The key for session ID persisted in keychain.
    var kSessionId: String {
        return persistencePrefix == nil ?
            "im.sr2k.TMDBKit.sessionId" :
            persistencePrefix! + "TMDBKit.sessionId"
    }
    /// Read-only. The key for guest session ID persisted by UserDefaults.
    var kGuestSessionId: String {
        return persistencePrefix == nil ?
            "im.sr2k.TMDBKit.guestSessionId" :
            persistencePrefix! + ".TMDBKit.guestSessionId"
    }
    /// Read-only. The key for guest session ID expire date persisted by UserDefaults.
    var kGuestSessionIdExpiresAt: String {
        return persistencePrefix == nil ?
            "im.sr2k.TMDBKit.guestSessionIdExpDate" :
            persistencePrefix! + ".TMDBKit.guestSessionIdExpDate"
    }
    
    /// Read-only. The session ID persisted in keychain.
    ///
    /// See [this](https://developers.themoviedb.org/3/authentication)
    /// for more info about session ID.
    internal(set) public var sessionId: String? {
        get {
            if let accessTokenData = KeychainManager.loadData(forKey: kSessionId) {
                if let accessTokenString = String.init(data: accessTokenData, encoding: .utf8) {
                    return accessTokenString
                }
            }
            
            return nil
        }
        set {
            if newValue == nil {
                KeychainManager.deleteItem(forKey: kSessionId)
            } else {
                let savingSucceeded = KeychainManager.setString(value: newValue!, forKey: kSessionId)
                print("SessionID saved successfully:\n\(savingSucceeded)")
            }
        }
    }
    
    /// Your guest session ID. This value will be persisted by UserDefaults.
    ///
    /// See [this](https://developers.themoviedb.org/3/authentication/create-guest-session)
    /// for more info about guest session ID.
    internal(set) public var guestSessionId: String? {
        get {
            return UserDefaults.standard.object(forKey: kGuestSessionId) as? String
        }
        
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: kGuestSessionId)
                return
            }
            UserDefaults.standard.set(value, forKey: kGuestSessionId)
        }
    }
    /// The expire time for the guest session ID.
    internal(set) public var guestSessionExpiresAt: Date? {
        get {
            return UserDefaults.standard.object(forKey: kGuestSessionIdExpiresAt) as? Date
        }
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: kGuestSessionIdExpiresAt)
                return
            }
            UserDefaults.standard.set(value, forKey: kGuestSessionIdExpiresAt)
        }
    }
    
    /// Image base URL.
    internal(set) public var imageBaseUrlString: String? {
        get {
            return persistencePrefix == nil ?
                nil :
                UserDefaults.standard.object(forKey: "\(persistencePrefix!).imageBaseUrlString") as? String
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
            return persistencePrefix == nil ?
                nil :
                UserDefaults.standard.object(forKey: "\(persistencePrefix!).secureImageBaseUrlString") as? String
        }
        
        set {
            guard let persistencePrefix = persistencePrefix else { return }
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).secureImageBaseUrlString")
        }
    }
    
    /// Change keys.
    internal(set) public var changeKeys: [String] {
        get {
            if
                let persistencePrefix = persistencePrefix,
                let changeKeys = UserDefaults.standard.object(forKey: "\(persistencePrefix).changeKeys") as? [String] {
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
    
    
    /// Avaliable backdrop sizes, include `rawSizes`, `width`, `heights` properties.
    /// Use configuration API to get this. This value will be persisted via UserDefaults.
    internal(set) public var avaliableBackdropSizes: TMDBAvaliableSizes? {
        get { return getImageSizes("backdropSizes") } set { setImageSizes("backdropSizes", newValue) }
    }
    
    /// Avaliable logo sizes, include `rawSizes`, `width`, `heights` properties.
    /// Use configuration API to get this. This value will be persisted via UserDefaults.
    internal(set) public var avaliableLogoSizes: TMDBAvaliableSizes? {
        get { return getImageSizes("logoSizes") } set { setImageSizes("logoSizes", newValue) }
    }
    
    /// Avaliable poster sizes, include `rawSizes`, `width`, `heights` properties.
    /// Use configuration API to get this. This value will be persisted via UserDefaults.
    internal(set) public var avaliablePosterSizes: TMDBAvaliableSizes? {
        get { return getImageSizes("posterSizes") } set { setImageSizes("posterSizes", newValue) }
    }
    
    /// Avaliable profile sizes, include `rawSizes`, `width`, `heights` properties.
    /// Use configuration API to get this. This value will be persisted via UserDefaults.
    internal(set) public var avaliableProfileSizes: TMDBAvaliableSizes? {
        get { return getImageSizes("profileSizes") } set { setImageSizes("profileSizes", newValue) }
    }
    
    /// Avaliable still sizes, include `rawSizes`, `width`, `heights` properties.
    /// Use configuration API to get this. This value will be persisted via UserDefaults.
    internal(set) public var avaliableStillSizes: TMDBAvaliableSizes? {
        get { return getImageSizes("stillSizes") } set { setImageSizes("stillSizes", newValue) }
    }
    
    /// [Account API](https://developers.themoviedb.org/3/account) wrapper.
    public let account = AccountAPIWrapper()
    /// [Authentication API](https://developers.themoviedb.org/3/authentication) wrapper.
    public let authentication = AuthenticationAPIWrapper()
    /// [Certifications API](https://developers.themoviedb.org/3/certifications) wrapper.
    public let certifications = CertificationsAPIWrapper()
    /// [Changes API](https://developers.themoviedb.org/3/changes) wrapper.
    public let changes = ChangesAPIWrapper()
    /// [Collections API](https://developers.themoviedb.org/3/collections) wrapper.
    public let collections = CollectionsAPIWrapper()
    /// [Companies API](https://developers.themoviedb.org/3/companies) wrapper.
    public let companies = CompaniesAPIWrapper()
    /// [Configuration API](https://developers.themoviedb.org/3/configuration) wrapper.
    public let configuration = ConfigurationAPIWrapper()
    /// [Credits API](https://developers.themoviedb.org/3/credits) wrapper.
    /// - TODO: A lot 😂
    public let credits = CreditsAPIWrapper()
    /// [Discover API](https://developers.themoviedb.org/3/discover) wrapper.
    public let discover = DiscoverAPIWrapper()
    /// [Find API](https://developers.themoviedb.org/3/find) wrapper.
    public let find = FindAPIWrapper()
    /// [Genres API](https://developers.themoviedb.org/3/genres) wrapper.
    public let genres = GenresAPIWrapper()
    /// [Guest Sessions API](https://developers.themoviedb.org/3/guest-sessions) wrapper.
    public let guestSession = GuestSessionAPIWrapper()
    /// [Jobs API](https://developers.themoviedb.org/3/jobs) wrapper.
    public let jobs = JobsAPIWrapper()
    /// [Keywords API](https://developers.themoviedb.org/3/keywords) wrapper.
    public let keywords = KeywordsAPIWrapper()
    /// [Lists API](https://developers.themoviedb.org/3/lists) wrapper.
    public let lists = ListsAPIWrapper()
    /// [Movies API](https://developers.themoviedb.org/3/movies) wrapper.
    /// - TODO:
    ///   - Credits
    ///   - append_to_response support
    public let movies = MoviesAPIWrapper()
    /// [Networks API](https://developers.themoviedb.org/3/networks) wrapper.
    public let networks = NetworksAPIWrapper()
    /// [People API](https://developers.themoviedb.org/3/people) wrapper.
    /// - TODO: append_to_response support
    public let people = PeopleAPIWrapper()
    /// [Search API](https://developers.themoviedb.org/3/search) wrapper class.
    /// - TODO: Multi search.
    public let search = SearchAPIWrapper()
    /// [Timezones API](https://developers.themoviedb.org/3/timezones) wrapper.
    public let timezones = TimezonesAPIWrapper()
    /// [TV API](https://developers.themoviedb.org/3/tv) wrapper class.
    /// - TODO:
    ///   - Append to response support.
    ///   - TV changes model.
    ///   - Credits model.
    public let tv = TVAPIWrapper()
}

extension TMDBManager {
    /// Setup the TMDB client.
    ///
    /// - Parameters:
    ///   - apiKey: Your API key, see [TMDB API - Introduction](https://developers.themoviedb.org/3/getting-started)
    /// for more info.
    ///   - persistencePrefix: Prefix for persistence keys. Usually your app's bundle name. For example, you set
    /// this value as **com.yourCompanyName.yourAppName**, this value is used as:
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
            guestSessionId != nil,
            let guestSessionExpiresAt = guestSessionExpiresAt
        else { return false }
        
        return guestSessionExpiresAt <= Date()
    }
}

extension TMDBManager {
    func getImageSizes(_ type: String) -> TMDBAvaliableSizes? {
        return persistencePrefix == nil ?
            nil :
            UserDefaults.standard.object(forKey: "\(persistencePrefix!).\(type)") as? TMDBAvaliableSizes
    }
    
    func setImageSizes(_ type: String, _ newValue: TMDBAvaliableSizes?) {
        guard let persistencePrefix = persistencePrefix else { return }
        if let newValue = newValue {
            UserDefaults.standard.set(newValue, forKey: "\(persistencePrefix).\(type)")
        } else {
            UserDefaults.standard.removeObject(forKey: "\(persistencePrefix).\(type)")
        }
    }
}
