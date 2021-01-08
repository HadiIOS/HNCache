//
//  HNUserDefaultsStorageTestCase.swift
//  StorageTestings
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import XCTest
@testable import HNStorage

class TestClass: Codable, Storable {
    var name: String
    let id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    var primaryKey: String { return id }
}


class HNUserDefaultsStorageTestCase: XCTestCase {
    
    func testInsertTwoObjectsSuccessfully() {
        let test1 = TestClass(name: "test1", id: "1")
        let test2 = TestClass(name: "name2", id: "2")
        do {
            try HNStorage<HNUserDefaultsStorage>().insert(test2)
            try HNStorage<HNUserDefaultsStorage>().insert(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        
        let o_test1: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("1")
        let o_test2: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("2")
        
        XCTAssertEqual(test1.name, o_test1?.name)
        XCTAssertEqual(test1.id, o_test1?.id)
        XCTAssertEqual(test2.name, o_test2?.name)
        XCTAssertEqual(test2.id, o_test2?.id)
    }
    
    func testUpdateAnObject() {
        let test1 = TestClass(name: "test1", id: "1")
        do {
            try HNStorage<HNUserDefaultsStorage>().insert(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        let o_test1: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("1")
        XCTAssertEqual("test1", o_test1?.name)
        XCTAssertEqual("1", o_test1?.id)
        
        test1.name = "test2"
        do {
            try HNStorage<HNUserDefaultsStorage>().update(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }

        let o_test2: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("1")
        XCTAssertEqual("test2", o_test2?.name)
        XCTAssertEqual("1", o_test2?.id)
    }
    
    func testDeleteAnObject() {
        let test1 = TestClass(name: "test1", id: "1")
        let test2 = TestClass(name: "name2", id: "2")
        
        do {
            try HNStorage<HNUserDefaultsStorage>().insert(test2)
            try HNStorage<HNUserDefaultsStorage>().insert(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        

        let o_test1: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("1")
        let o_test2: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("2")

        XCTAssertEqual(test1.name, o_test1?.name)
        XCTAssertEqual(test1.id, o_test1?.id)
        XCTAssertEqual(test2.name, o_test2?.name)
        XCTAssertEqual(test2.id, o_test2?.id)
        
        do {
            try HNStorage<HNUserDefaultsStorage>().delete(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        
        
        let o_test1_: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("1")
        let o_test2_: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("2")

        XCTAssertEqual(o_test1_?.name, nil)
        XCTAssertEqual(o_test1_?.id, nil)
        XCTAssertEqual(test2.name, o_test2_?.name)
        XCTAssertEqual(test2.id, o_test2_?.id)
    }
    
    func testInsertObjectWithNamedUserDefaults() {
        let userDefaultsSuitName: String = "hn.test.userdefaultssuit"
        let test1 = TestClass(name: "test1", id: "1")
        let test2 = TestClass(name: "test2", id: "2")
        //make sure to clean up
        try? HNStorage<HNUserDefaultsStorage>().delete(test2)
        try? HNStorage<HNUserDefaultsStorage>(id: userDefaultsSuitName).delete(test1)

        //insert
        do {
            try HNStorage<HNUserDefaultsStorage>(id: userDefaultsSuitName).insert(test1)
            try HNStorage<HNUserDefaultsStorage>().insert(test2)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        
        //get
        let o_test1: TestClass? = try? HNStorage<HNUserDefaultsStorage>().get("2")
        let o_test2: TestClass? = try? HNStorage<HNUserDefaultsStorage>(id: userDefaultsSuitName).get("1")
        
        //test
        XCTAssertEqual(o_test2?.name, "test1")
        XCTAssertEqual(o_test2?.id, "1")
        XCTAssertEqual(o_test1?.name, "test2")
        XCTAssertEqual(o_test1?.id, "2")
    }
}
