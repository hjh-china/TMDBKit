//
//  KeyChainManager.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/17.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public class KeychainManager {
    
    static let serviceIdentifier = "im.sr2k.tmdbKit"
    
    static let kSecClassValue = kSecClass as String
    static let kSecAttrAccountValue = kSecAttrAccount as String
    static let kSecValueDataValue = kSecValueData as String
    static let kSecClassGenericPasswordValue = kSecClassGenericPassword as String
    static let kSecAttrServiceValue = kSecAttrService as String
    static let kSecMatchLimitValue = kSecMatchLimit as String
    static let kSecReturnDataValue = kSecReturnData as String
    static let kSecMatchLimitOneValue = kSecMatchLimitOne as String
    
    class func setString(value: String, forKey key: String) -> Bool {
        let data = value.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let keychainQuery: [String: Any] = [kSecClassValue: kSecClassGenericPasswordValue,
                                            kSecAttrAccountValue: key,
                                            kSecValueDataValue: data]
        
        SecItemDelete(keychainQuery as CFDictionary)
        
        let status: OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil)
        return status == noErr
    }
    
    class func loadData(forKey key: String) -> Data? {
        let keychainQuery: [String: Any] = [kSecClassValue: kSecClassGenericPasswordValue,
                                            kSecAttrAccountValue: key,
                                            kSecReturnDataValue: kCFBooleanTrue,
                                            kSecMatchLimitValue: kSecMatchLimitOneValue]
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(keychainQuery as CFDictionary, UnsafeMutablePointer($0)) }
        
        if status == -34018 {
            return dataTypeRef as? Data
        }
        
        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }
    
    @discardableResult
    class func deleteItem(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
    public class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
}
