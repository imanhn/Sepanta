//
//  SepantaGroupsViewController.swift
//  Sepanta
//
//  Created by Iman on 11/17/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class SepantaGroupsViewController : UIViewControllerWithCoordinator,UITextFieldDelegate,Storyboarded{
    var provincesCache : [String] = []
    var provinceDict : Dictionary = ["TEST":"TEST"];
    var cityDict : Dictionary = ["TEST":"TEST"];
    var cityCache : [String] = []
    var currentStateCode : String = ""
    var currentCityCode : String = ""
    @IBOutlet weak var selectCity: UnderLinedSelectableTextField!
    @IBOutlet weak var selectProvince: UnderLinedSelectableTextField!
    var provinceModel = provinces() {
        didSet {
            updateProvince()
            self.view.setNeedsLayout()
        }
    }
    var cityModel = cities() {
        didSet {
            updateCity()
            self.view.setNeedsLayout()
        }
    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        guard let acoordinator = coordinator as? HomeCoordinator else {
            return
        }
        acoordinator.start()
    }
    
    
    func updateProvince(){
        
        self.selectProvince.text = provinceModel.type
        
    }
    
    func updateCity(){
        
        self.selectCity.text = cityModel.type
        
    }
    
    func getAllProvince() {
        var provinceList : [String]=[];
        let urlAddress = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city")
        let aMethod : HTTPMethod = HTTPMethod.get
        print("Calling API")
        Alamofire.request(urlAddress! as URL, method: aMethod, parameters: nil, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response:DataResponse<Any>) in
            print("Processing Response....")
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil
                {
                    let jsonResult = JSON(response.result.value!)
                    for aProv in jsonResult["states"]
                    {
                        print(aProv.0," ",aProv.1)
                        let provName : String = aProv.0
                        self.provinceDict[provName] = aProv.1.rawString()!
                        provinceList.append(provName)
                        
                    }
                    
                    print("Fetched : ",provinceList.count," record")
                    //print("Provinces : ",provinceList)
                    print("Successful")
                    self.provincesCache = provinceList.sorted()
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
    
    func getAllProvinceList() -> Array<String> {
        if provincesCache.count == 0 {
            print("Province list not ready yet")
            getAllProvince()
            return ["مجدد تلاش کنید"];
        }else{
            return provincesCache
        }
    }
    func getAllCity(_ stateCode : String) {
        var cityList : [String]=[];
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        let parameters = [
            "state code": stateCode
        ]
        //        let urlAddress = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city?state code="+stateCode)
        let postURL = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city?state%20code="+stateCode)! as URL
        let aMethod : HTTPMethod = HTTPMethod.post
        print("Calling City API")
        Alamofire.request(postURL, method: aMethod, parameters: parameters, encoding: JSONEncoding.default,  headers: headers).responseJSON { (response:DataResponse<Any>) in
            print("Processing City Response....")
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil
                {
                    let jsonResult = JSON(response.result.value!)
                    //cityList = Array<String>(repeating: "", count: jsonResult["cities"].count)
                    for aCity in jsonResult["cities"]
                    {
                        print(aCity.0," ",aCity.1)
                        let cityName : String = aCity.0
                        let idx = Int(aCity.1.rawString()!)!
                        self.cityDict[cityName] = aCity.1.rawString()!
                        cityList.append(cityName)
                        
                    }
                    
                    print("Fetched : ",cityList.count," record")
                    //print("Cities : ",cityList)
                    print("Successful")
                    self.cityCache = cityList.sorted()
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
    
    func getAllCityList() -> Array<String> {
        if cityCache.count == 0 {
            print("City list not ready yet for ",currentStateCode)
            getAllCity(currentStateCode)
            return ["مجدد تلاش کنید"];
        }else{
            return cityCache
        }
    }
    
    @IBAction func cityPressed(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllCityList()) {
            (type) in self.cityModel.type = type
            print("City Code : ",self.cityDict[type]!)
            self.currentCityCode = self.cityDict[type] as! String
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 400)
        showPopup(controller, sourceView: sender as! UIView)
        selectCity.resignFirstResponder()
    }
    
    @IBAction func provincePressed(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllProvinceList()) {
            (type) in self.provinceModel.type = type
            self.selectCity.text = ""
            print("State Code : ",self.provinceDict[type]!)
            self.currentStateCode = self.provinceDict[type] as! String
            self.getAllCity(self.provinceDict[type]!)
            
        }
        controller.preferredContentSize = CGSize(width: 250, height: 400)
        showPopup(controller, sourceView: sender as! UIView)
    }
    override func viewDidLoad() {
        //        getAllProvince()
        super.viewDidLoad()
        definesPresentationContext = true
        selectCity.delegate = self
        selectProvince.delegate = self
        
        selectCity.resignFirstResponder()
        selectProvince.resignFirstResponder()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
