//
//  HNStorage.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import Foundation

@objc public enum HNStorageError: Int, Error {
    case objectNotConformedToCodable
    case objectNotFound
    case storageErrorOccured
}

internal final class SASStorage<S: Storage>: Storage {
    
    private let storage: S
    
    static func setup() {
        S.setup()
    }
    
    init() {
        storage = S.init(id: nil)
    }
    
    init(id: String?) { 
        storage = S.init(id: id)
    }
    
    @nonobjc public func insert(_ object: Storable) throws {
        try storage.insert(object)
    }
    
    @nonobjc public func update(_ object: Storable) throws {
        try storage.update(object)
    }
    
    @nonobjc public func delete(_ object: Storable) throws {
        try storage.delete(object)
    }
    
    @nonobjc public func exists(_ object: Storable) throws -> Bool {
        try storage.exists(object)
    }
    
    @nonobjc public func get<T: Storable>(_ key: String) throws -> T? {
        try storage.get(key)
    }
}
