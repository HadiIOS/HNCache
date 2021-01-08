//
//  HNStorage+Protocol.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import Foundation
//MARK:- Storage Protocol -
typealias Storage = StorageInitializable & StorageType

public protocol StorageType {
    func insert(_ object: Storable) throws
    func update(_ object: Storable) throws
    func delete(_ object: Storable) throws
    func exists(_ object: Storable) throws -> Bool
    func get<T: Storable>(_ key: String) throws -> T?
}

public protocol StorageInitializable {
    ///init with an id 
    init(id: String?)
    static func setup()
}

//MARK:- Storable Protocol-
public protocol Storable {
    var primaryKey: String { get }
    
    func encode() throws -> Data
    static func decode(_ data: Data) throws -> Self?
}

extension Storable where Self: Codable {
    func encode() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    static func decode<T>(_ data: Data) throws -> T? where T : Storable {
        return try JSONDecoder().decode(Self.self, from: data) as? T
    }
}


internal extension StorageType {
    func getEncoded(_ object: Storable) throws -> Data? {
       do {
            return try object.encode()
        } catch {
            throw HNStorageError.objectNotConfirmingToStorableCoding
        }
    }
    
    func getDecoded<T: Storable>(data: Data) throws -> T? {
        do {
            return try T.decode(data)
        } catch {
            throw HNStorageError.objectNotConfirmingToStorableCoding
        }
    }
}

internal extension StorageInitializable {
    static func setup() { }
}

