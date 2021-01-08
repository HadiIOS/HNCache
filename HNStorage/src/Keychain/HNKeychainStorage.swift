//
//  HNKeychainStorage.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import Foundation

final public class HNKeychainStorage: Storage {
    let name: String

    public init(id: String?) {
        name = id ?? "hnstorage.defaultservice.storageservice"
    }
    
    public func insert(_ object: Storable) throws {
        if let data = try getEncoded(object) {
            let addQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                          kSecAttrAccount: object.primaryKey,
                                          kSecAttrService: self.name,
                                          kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
                                          kSecValueData: data]
            
            let status = SecItemAdd(addQuery, nil)
            guard status == errSecSuccess else {
                throw HNStorageError.storageErrorOccured
            }
        } else {
            throw HNStorageError.objectNotConformedToCodable
        }
    }
    
    public func update(_ object: Storable) throws {
        if let data = try getEncoded(object) {
            let updateQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                             kSecAttrAccount: object.primaryKey,
                                             kSecAttrService: self.name]
            let status = SecItemUpdate(updateQuery, [kSecValueData: data] as NSDictionary)
            guard status == errSecSuccess else {
                throw HNStorageError.storageErrorOccured
            }

        } else {
            throw HNStorageError.objectNotConformedToCodable
        }
    }
    
    public func delete(_ object: Storable) throws {
        let deleteQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrAccount: object.primaryKey,
                                         kSecAttrService: self.name]
        let status = SecItemDelete(deleteQuery)
        guard status == errSecSuccess else {
            throw HNStorageError.storageErrorOccured
        }
    }
    
    public func exists(_ object: Storable) throws -> Bool {
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrAccount: object.primaryKey,
                                   kSecAttrService: name,
                                   kSecReturnData: false]
        
        let status = SecItemCopyMatching(query , nil)
        if (status == errSecSuccess) {
            return true
        } else if (status == errSecItemNotFound) {
            return false
        } else {
            throw HNStorageError.storageErrorOccured
        }
    }
    
    public func get<T>(_ key: String) throws -> T? where T : Storable {
        var result: AnyObject?
        let fetchQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: key,
                                        kSecAttrService: self.name,
                                        kSecReturnData: true]
        let status = SecItemCopyMatching(fetchQuery, &result)
        if (status == errSecSuccess) {
            if let data = result as? Data {
                if let decoded: T = try getDecoded(data: data) {
                    return decoded
                } else {
                    throw HNStorageError.objectNotConformedToCodable
                }
            } else {
                return nil
            }
            
        } else if (status == errSecItemNotFound) {
            return nil
        } else {
            throw HNStorageError.storageErrorOccured
        }
    }
}
