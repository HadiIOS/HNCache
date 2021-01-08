//
//  HNUserDefaultsStorage.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import Foundation

final public class HNUserDefaultsStorage: Storage {
    let userDefaults: UserDefaults
    
    public init(id: String?) {
        userDefaults = UserDefaults(suiteName: id) ?? UserDefaults.standard
    }
    
    public func insert(_ object: Storable) throws {
        userDefaults.setValue(try? object.encode(), forKey: object.primaryKey)
    }
    
    public func update(_ object: Storable) throws {
        try self.insert(object)
    }
    
    public func delete(_ object: Storable) throws {
        userDefaults.removeObject(forKey: object.primaryKey)

    }
    
    public func exists(_ object: Storable) throws -> Bool {
        return userDefaults.object(forKey: object.primaryKey) != nil
    }
    
    public func get<T>(_ key: String) throws -> T? where T : Storable {
        if let data = userDefaults.object(forKey: key) as? Data {
            if let decoded: T = try getDecoded(data: data) {
                return decoded
            } else {
                throw HNStorageError.objectNotConformedToCodable
            }
        }
        return nil
    }
    
    
}
