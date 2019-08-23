//
//  TypeConversionTests.swift
//  SepantaTests
//
//  Created by Iman on 5/26/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import XCTest
@testable import Sepanta

class TypeConversionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDictionaryConversion() {
        let aNSDic: NSMutableDictionary = NSMutableDictionary()
        aNSDic.setValue("VALUE1", forKey: "KEY1")
        aNSDic.setValue("VALUE2", forKey: "KEY2")
        var aDic = (aNSDic as NSDictionary).toStringDictionary
        XCTAssert((aDic["KEY1"] == "VALUE1") && (aDic["KEY1"] == "VALUE1"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
