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
        do{
            let mobile = try checkMobile(MobileNumberPrefix : "0912").results().toBlocking().first()
            XCTAssertEqual(mobile?.name, "همراه اول","API Route Failed")
        }catch{
            XCTFail()
        }
    }
    
    func testCheckBank(){
        do{
            let bank1 = try checkBank(SixDigitPrefix : "603799").results().toBlocking().first()
            XCTAssertEqual(bank1?.bank, "بانک ملی ایران","API Route Failed")
            let bank2 = try checkBank(SixDigitPrefix : "610433").results().toBlocking().first()
            XCTAssertEqual(bank2?.bank, "بانک ملت","API Route Failed")
        }catch{
            XCTFail()
        }
        
    }
    
    func testGetProfile() {
        do {
            let pinfo = try getProfileInfo().results().toBlocking().first()
            XCTAssertEqual(pinfo?.status, "successful","API Route Failed")
            XCTAssertEqual(pinfo?.id, 49,"API Route Failed")
        }
        catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }
    
    func testNotifications() {
        do {
            let noti = try getNotifications(Page : 1).results().toBlocking().first()
            XCTAssertEqual(noti?.status, "successful","API Route Failed")
            XCTAssertEqual(noti?.notifications_user.current_page, 1,"API Route Failed")
            XCTAssertEqual(noti?.notifications_user.data.count, noti?.notifications_user.total,"API Route Failed")
        }
        catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }
    
    func testHomeData() {
        do {
            let home = try getHomeData().results().toBlocking().first()
            XCTAssertEqual(home?.status, "successful","API Route Failed")
            XCTAssertTrue((home?.sliders!.count)! > 0,"Sliders is empty!")
            XCTAssertNotNil(home?.sliders?.first?.images,"First Slider does not have a valid image")
        }
        catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }
    
    func testCategoryFilter() {
        do {

            let allCat = try getAllCategories().results().toBlocking().first()
            XCTAssertTrue((allCat?.categories.count)! > 0,"allCat is empty!")
            XCTAssertNotNil(allCat?.categories.first!.image,"First allCat does not have a valid image")

            let cityCat = try getCityCategories(CityCode: "329").results().toBlocking().first()
            XCTAssertTrue((cityCat?.categories.count)! > 0,"cityCat is empty!")
            XCTAssertNotNil(cityCat?.categories.first!.image,"First cityCat does not have a valid image")

            let stateCat = try getStateCategories(StateCode: "8").results().toBlocking().first()
            XCTAssertTrue((stateCat?.categories.count)! > 0,"stateCat is empty!")
            XCTAssertNotNil(stateCat?.categories.first!.image,"First stateCat does not have a valid image")

            
        }
        catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }
    
    func testRate() {
        do {
            let rate = try setRate(Rate: 3, ShopID: 2).results().toBlocking().first()
            XCTAssertEqual(rate?.status, "successful","API Route Failed")
            XCTAssertNotNil(rate?.rate_count,"rate_count is nil!")
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
