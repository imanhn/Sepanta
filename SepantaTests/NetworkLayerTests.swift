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
            } else {
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

    func testMobile() {
        do {
            let mobile = try checkMobile(MobileNumberPrefix: "0912").results().toBlocking().first()
            XCTAssertEqual(mobile?.name, "همراه اول", "API Route Failed")
        } catch {
            XCTFail()
        }
    }

    func testCheckBank() {
        do {
            let bank1 = try checkBank(SixDigitPrefix: "603799").results().toBlocking().first()
            XCTAssertEqual(bank1?.bank, "بانک ملی ایران", "API Route Failed")
            let bank2 = try checkBank(SixDigitPrefix: "610433").results().toBlocking().first()
            XCTAssertEqual(bank2?.bank, "بانک ملت", "API Route Failed")
        } catch {
            XCTFail()
        }

    }

    func testGetProfile() {
        do {
            let pinfo = try getProfile().results().toBlocking().first()
            XCTAssertEqual(pinfo?.status, "successful", "API Route Failed")
            XCTAssertEqual(pinfo?.id, 49, "API Route Failed")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testNotifications() {
        do {
            let noti = try getNotifications(Page: 1).results().toBlocking().first()
            XCTAssertEqual(noti?.status, "successful", "API Route Failed")
            XCTAssertEqual(noti?.notifications_user?.current_page, 1, "API Route Failed")
            XCTAssertEqual(noti?.notifications_user!.data.count, noti?.notifications_user?.total, "API Route Failed")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testHomeData() {
        do {
            let home = try getHomeData().results().toBlocking().first()
            XCTAssertEqual(home?.status, "successful", "API Route Failed")
            XCTAssertTrue((home?.sliders!.count)! > 0, "Sliders is empty!")
            XCTAssertNotNil(home?.sliders?.first?.images, "First Slider does not have a valid image")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testCategoryFilter() {
        do {

            let allCat = try getAllCategories().results().toBlocking().first()
            XCTAssertTrue((allCat?.categories.count)! > 0, "allCat is empty!")
            XCTAssertNotNil(allCat?.categories.first!.image, "First allCat does not have a valid image")

            let cityCat = try getCityCategories(CityCode: "329").results().toBlocking().first()
            XCTAssertTrue((cityCat?.categories.count)! > 0, "cityCat is empty!")
            XCTAssertNotNil(cityCat?.categories.first!.image, "First cityCat does not have a valid image")

            let stateCat = try getStateCategories(StateCode: "8").results().toBlocking().first()
            XCTAssertTrue((stateCat?.categories.count)! > 0, "stateCat is empty!")
            XCTAssertNotNil(stateCat?.categories.first!.image, "First stateCat does not have a valid image")

        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testRate() {
        do {
            let rate = try setRate(Rate: 3, ShopID: 2).results().toBlocking().first()
            XCTAssertEqual(rate?.status, "successful", "API Route Failed")
            XCTAssertNotNil(rate?.rate_count, "rate_count is nil!")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testGetProfileInfo() {
        do {
            let aProfileInfo = try getProfileInfo().results().toBlocking().first()
            XCTAssertEqual(aProfileInfo?.status, "successful", "API Route Failed")
            XCTAssertNotNil(aProfileInfo?.first_name, "first_name is nil!")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testSetProfileInfo() {
        do {
            let aprofileinfo = ProfileInfo(First_name: "سید ایمان", Last_name: "حسینی نیا", Bio: "بایو", Banner: nil, Address: "سعادت", Image: "200_49-2019-06-20_16-56-52.jpg", National_code: "3051274615", State_id: "08", City_id: "329", Gender: "1", Birthdate: "1359/05/29", Email: "imanhn@gmail.com", Phone: "09121325450", Marital_status: "2")
            let returned = try setProfileInfo(ProfileInfo: aprofileinfo).results().toBlocking().first()
            XCTAssertEqual(returned?.status, "successful", "API Route Failed : "+"\(String(describing: returned?.status))")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testGetFavoriteList() {
        do {
            let aFavList = try getFavoriteList().results().toBlocking().first()
            XCTAssertEqual(aFavList!.status, "successful", "API Route Failed : "+"\(String(describing: aFavList?.status))")
            XCTAssertTrue(!aFavList!.favorite!.isEmpty, "Has not any favorite!")
            XCTAssertTrue(aFavList!.favorite![0].shop_id != nil, "a Shop in favorite list exists but has no id ")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testToggleFavorite() {
        do {
            let aFavList1 = try toggleFavorite(ShopId: "2").results().toBlocking().first()
            XCTAssertEqual(aFavList1!.status, "successful", "API Route Failed : "+"\(String(describing: aFavList1?.status))")
            let f1 = Int(aFavList1!.isFave!)
            XCTAssertNotNil(aFavList1!.isFave, "No is Fave")

            let aFavList2 = try toggleFavorite(ShopId: "2").results().toBlocking().first()
            let f2 = Int(aFavList2!.isFave!)
            XCTAssertEqual(f1!+f2!, 1, "Favorite Toggle does not work correctly on Back-End")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testToggleFollow() {
        do {
            let toggled1 = try toggleFollow(ShopId: "1").results().toBlocking().first()
            XCTAssertEqual(toggled1!.status, "successful", "API Route Failed : "+"\(String(describing: toggled1?.status))")

            let toggled2 = try toggleFollow(ShopId: "1").results().toBlocking().first()
            XCTAssertEqual(toggled2!.status, "successful", "API Route Failed : "+"\(String(describing: toggled2?.status))")
            //print("Toggle 1 : ",toggled1)
            //print("Toggle 2 : ",toggled2)
            XCTAssertTrue(abs(toggled1!.followers! - toggled2!.followers!) == 1, "Follow Unfollow does not work correctly!")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testGetShopsLocation() {
        do {
            let shopLocationList = try getShopsLocation(lat: 35.755985, long: 51.546742).results().toBlocking().first()
            XCTAssertEqual(shopLocationList?.status, "successful", "API Route Failed")
            XCTAssertTrue((shopLocationList?.shops!.count)! > 0, "No Shops Found")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testSendContactUs() {
        do {
            let sendForm = try sendContactUs(title: "انتقاد", body: "وجود تعداد زیاد فیچر باعث سردرگمی بنده شده است").results().toBlocking().first()
            XCTAssertEqual(sendForm?.status, "successful", "API Route Failed")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testGetLastCard() {
        do {
            let lastCard = try getLastCard().results().toBlocking().first()
            XCTAssertEqual(lastCard?.status, "successful", "API Route Failed")
            XCTAssertNotNil(lastCard?.card.cellphone, "Cell Phone is empty")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testGetPointScore() {
        do {
            let points = try getPointsScore().results().toBlocking().first()
            XCTAssertEqual(points?.status, "successful", "API Route Failed")
            XCTAssertTrue((points?.points!.count)! > 0, "Points is empty")
            XCTAssertTrue((points?.points_total)! > 100, "total points is empty")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testGetPostDetails() {
        do {
            let postDet = try getPostDetails(PostID: 2).results().toBlocking().first()
            XCTAssertEqual(postDet?.status, "successful", "API Route Failed")
            XCTAssertTrue((postDet?.is_like)! == 0 || (postDet?.is_like)! == 1, "is Like contain incorrect data")
            XCTAssertNotNil(postDet?.postDetail?.id, "id of post detail is empty")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testReportComment() {
        do {
            let rep = try reportComment(CommentID: 2, Description: "حاوی کلمات زشت است").results().toBlocking().first()
            XCTAssertEqual(rep?.status, "successful", "API Route Failed")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testReportPost() {
        do {
            let rep = try reportPost(PostID: 2, Description: "حاوی کلمات زشت است").results().toBlocking().first()
            XCTAssertEqual(rep?.status, "successful", "API Route Failed")
        } catch let error as NSError {
            print("Route Failed ", error.localizedDescription)
            XCTFail()
        }
    }

    func testCategoryShopsSlug3() {
        do {
            let shopList = try getCatagoryShops(CategoryID: 20).results().toBlocking().first()
            XCTAssertEqual(shopList?.status, "successful", "API Route Failed")
            XCTAssertNotNil(shopList?.shopList, "categoryShops is nil!!")
            XCTAssertTrue((shopList?.shopList!.count)! > 0, "No Shops Found!!")
            //XCTAssertNotNil(shopList?.lastPage, "Last Page is nil!!")
            //XCTAssertNotNil(shopList?.currentPage, "Current Page is nil!!")
        } catch let error as NSError {
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
