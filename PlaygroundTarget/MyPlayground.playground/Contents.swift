//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import PlaygroundFrameWork
import SwiftyJSON
import Alamofire
var arrRes = [[String:AnyObject]]()
var jsonResult : AnyObject
var str = "Hello, playground"
let headers: HTTPHeaders = [
    "Accept": "application/json",
    "Content-Type":"application/x-www-form-urlencoded"
]
let parameters = [
    "phone" : "09121325450",
    "gender" : "1",
    "state" : "23",
    "city" : "01",
    "username" : "iman"
]
 let urlString = "http://www.favecard.ir/api/takamad/register?phone="+parameters["phone"]+"&gender="+parameters["gender"]+"&state="+parameters["state"]+"&city="+parameters["city"]+"&username="+parameters["username"]

let postURL = NSURL(string: urlString)! as URL

let aMethod : HTTPMethod = HTTPMethod.post

Alamofire.request(postURL, method: aMethod, parameters: parameters, encoding: JSONEncoding.default,  headers: headers).responseJSON { (response:DataResponse<Any>) in
    self.arrRes = JSON(response.result.value!)
}

