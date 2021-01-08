//
//  HNDiskStorageTestCase.swift
//  StorageTestings
//
//  Created by Hadi Nourallah on 2021-01-09.
//

import XCTest
@testable import HNStorage

class HNDiskStorageTestCase: XCTestCase {
    
    func testInsertTwoObjectsSuccessfully() {
        let test1 = TestClass(name: "test1", id: "1")
        let test2 = TestClass(name: "name2", id: "2")
        do {
            
            try HNStorage<HNDiskStorage>().insert(test2)
            try HNStorage<HNDiskStorage>().insert(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        
        let o_test1: TestClass? = try? HNStorage<HNDiskStorage>().get("1")
        let o_test2: TestClass? = try? HNStorage<HNDiskStorage>().get("2")
        
        XCTAssertEqual(test1.name, o_test1?.name)
        XCTAssertEqual(test1.id, o_test1?.id)
        XCTAssertEqual(test2.name, o_test2?.name)
        XCTAssertEqual(test2.id, o_test2?.id)
    }
    
    func testUpdateAnObject() {
        let test1 = TestClass(name: "test1", id: "1")
        do {
            try HNStorage<HNDiskStorage>().insert(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        let o_test1: TestClass? = try? HNStorage<HNDiskStorage>().get("1")
        XCTAssertEqual("test1", o_test1?.name)
        XCTAssertEqual("1", o_test1?.id)
        
        test1.name = "test2"
        do {
            try HNStorage<HNDiskStorage>().update(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }

        let o_test2: TestClass? = try? HNStorage<HNDiskStorage>().get("1")
        XCTAssertEqual("test2", o_test2?.name)
        XCTAssertEqual("1", o_test2?.id)
    }
    
    func testDeleteAnObject() {
        let test1 = TestClass(name: "test1", id: "1")
        let test2 = TestClass(name: "name2", id: "2")
        
        do {
            try HNStorage<HNDiskStorage>().insert(test2)
            try HNStorage<HNDiskStorage>().insert(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        

        let o_test1: TestClass? = try? HNStorage<HNDiskStorage>().get("1")
        let o_test2: TestClass? = try? HNStorage<HNDiskStorage>().get("2")

        XCTAssertEqual(test1.name, o_test1?.name)
        XCTAssertEqual(test1.id, o_test1?.id)
        XCTAssertEqual(test2.name, o_test2?.name)
        XCTAssertEqual(test2.id, o_test2?.id)
        
        do {
            try HNStorage<HNDiskStorage>().delete(test1)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        
        
        let o_test1_: TestClass? = try? HNStorage<HNDiskStorage>().get("1")
        let o_test2_: TestClass? = try? HNStorage<HNDiskStorage>().get("2")

        XCTAssertEqual(o_test1_?.name, nil)
        XCTAssertEqual(o_test1_?.id, nil)
        XCTAssertEqual(test2.name, o_test2_?.name)
        XCTAssertEqual(test2.id, o_test2_?.id)
    }
    
    func testInsertObjectWithNamedUserDefaults() {
        let userDefaultsSuitName: String = "hntestcase.test.cacheMemorysuit"
        let test1 = TestClass(name: "test1", id: "1")
        let test2 = TestClass(name: "test2", id: "2")
        //make sure to clean up
        try? HNStorage<HNDiskStorage>().delete(test2)
        try? HNStorage<HNDiskStorage>(id: userDefaultsSuitName).delete(test1)

        //insert
        do {
            try HNStorage<HNDiskStorage>(id: userDefaultsSuitName).insert(test1)
            try HNStorage<HNDiskStorage>().insert(test2)
        } catch {
            XCTAssert(true, error.localizedDescription)
        }
        
        //get
        let o_test1: TestClass? = try? HNStorage<HNDiskStorage>().get("2")
        let o_test2: TestClass? = try? HNStorage<HNDiskStorage>(id: userDefaultsSuitName).get("1")
        
        //test
        XCTAssertEqual(o_test2?.name, "test1")
        XCTAssertEqual(o_test2?.id, "1")
        XCTAssertEqual(o_test1?.name, "test2")
        XCTAssertEqual(o_test1?.id, "2")
    }
}
