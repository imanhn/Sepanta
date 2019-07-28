//
//  SepantaTests.swift
//  SepantaTests
//
//  Created by Iman on 11/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import XCTest
import Foundation
import UIKit
import Alamofire
import RxTest
import RxSwift
import RxBlocking

@testable import Sepanta

class NetworkLayerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        if LoginKey.shared.isLoggedIn() {
            if LoginKey.shared.retrieveTokenAndUserID() {
                print("XCTEST: Token and User Data retrieved..")
            }else{
                print("XCTEST: DEMO Token and User Data loaded..")
                LoginKey.shared.loadUserDemoLoginCredentials()
            }
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMobile(){
        //XCTFail()
    }
    
    func testCheckBank(){
        do{
            let bank1 = try checkBank(SixDigitPrefix : "603799").results().toBlocking().first()
            XCTAssertEqual(bank1?.status, "successful","API Route Failed")
        }catch{
            XCTFail()
        }
        
    }
    
    func testGetProfile() {
        do {
            let pinfo = try getProfileInfo().results().toBlocking().first()
            XCTAssertEqual(pinfo?.status, "successful","API Route Failed")
        }
        catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }
    
    func testPerformanceExample() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
