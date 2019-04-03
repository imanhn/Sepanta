//
//  SepantaTests.swift
//  SepantaTests
//
//  Created by Iman on 11/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit
import Alamofire


@testable import Sepanta

class SepantaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testRegisteringUser(){
        func registerUser(MobileNumber : String,GenderCode : String,Username : String){
            
            
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type":"application/x-www-form-urlencoded"
            ]
            let parameters = [
                "phone" : MobileNumber,
                "gender" : GenderCode,
                "state" : currentStateCode,
                "city" : currentCityCode,
                "username" : Username
            ]
            let urlString = "http://www.favecard.ir/api/takamad/register?phone="+MobileNumber+"&gender="+GenderCode+"&state="+currentStateCode+"&city="+currentCityCode+"&username="+Username
            let postURL = NSURL(string: urlString)! as URL
            let aMethod : HTTPMethod = HTTPMethod.post
            print("Calling Register API")
            Alamofire.request(postURL, method: aMethod, parameters: parameters, encoding: JSONEncoding.default,  headers: headers).responseJSON { (response:DataResponse<Any>) in
                print("Processing Register Response....")
                switch(response.result) {
                case .success(_):
                    
                    if response.result.value != nil
                    {
                        var signupResultMessage : String = ""
                        let jsonResult = JSON(response.result.value!)
                        
                        if let resData = jsonResult["status"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            if self.arrRes.count > 0 {
                                print("status arrRes count : ",self.arrRes.count)
                            }else{
                                print("status arrRes count : 0 ",self.arrRes)
                            }
                        }
                        if let resData = jsonResult["phone"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            if self.arrRes.count > 0 {
                                print("phone arrRes count : ",self.arrRes.count)
                            }else{
                                print("phone arrRes count : 0 ",self.arrRes)
                            }
                        }
                        /*
                         if jsonResult["userid"].string != nil {
                         let str = jsonResult["userid"].arrayValue[0].string!
                         print("UserID : ",str)
                         signupResultMessage = signupResultMessage + str + "\n"
                         }
                         
                         if jsonResult["message"].string != nil {
                         let str = jsonResult["message"].arrayValue[0].string!
                         print("Message : ",str)
                         signupResultMessage = signupResultMessage + str + "\n"
                         }
                         
                         
                         if jsonResult["status"].string != nil {
                         let str = jsonResult["status"].arrayValue[0].string!
                         print("Status : ",str)
                         signupResultMessage = signupResultMessage + str + "\n"
                         }
                         
                         if jsonResult["phone"].string != nil {
                         let str = jsonResult["phone"].arrayValue[0].string!
                         print("Phone : ",str)
                         signupResultMessage = signupResultMessage + str + "\n"
                         }
                         
                         if jsonResult["username"].string != nil {
                         let str = jsonResult["username"].arrayValue[0].string!
                         print("Username : ",str)
                         signupResultMessage = signupResultMessage + str
                         }
                         */
                        print("Message : ",signupResultMessage)
                        print("Successful")
                    }
                    break
                    
                case .failure(_):
                    if response.result.error != nil
                    {
                        print("Not Successful")
                        print(response.result.error!)
                    }
                    break
                }
                
            }
            
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
