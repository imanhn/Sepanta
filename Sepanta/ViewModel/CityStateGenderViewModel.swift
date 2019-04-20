//
//  CityStateGenderViewModel.swift
//  Sepanta
//
//  Created by Iman on 1/31/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

protocol VCWithCityAndState {
    var selectCity : UITextField? {set get}
    var selectProvince : UITextField? {set get}
}

protocol VCWithCityAndStateAndGender : VCWithCityAndState{
    var genderTextField : UITextField? {set get}
}

struct genders {
    var type : String = "جنسیت"
}

struct provinces {
    var type : String = "انتخاب استان"
}

struct cities {
    var type : String = "انتخاب شهر"
}

class CityStateViewModel {
    var ownerVC : UIViewController & VCWithCityAndState
    var myDisposeBag = DisposeBag()
    init(_ vc : UIViewController & VCWithCityAndState){
        self.ownerVC = vc
    }
    
    var provinceModel = provinces() {
        didSet {
            updateProvince()
            self.ownerVC.view.setNeedsLayout()
        }
    }
    
    var cityModel = cities() {
        didSet {
            updateCity()
            self.ownerVC.view.setNeedsLayout()
        }
    }

    func updateProvince(){
        self.ownerVC.selectProvince!.text = provinceModel.type
        self.ownerVC.selectProvince!.resignFirstResponder()
    }
    
    func updateCity(){
        self.ownerVC.selectCity!.text = cityModel.type
        self.ownerVC.selectCity!.resignFirstResponder()
    }
    
    func provinceTextTouchDown(_ sender: Any) {
        //var outsideController = ArrayChoiceTableViewController<String>()
        Spinner.start()
        NetworkManager.shared.run(API: "get-state-and-city",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
        NetworkManager.shared.provinceDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerProvinceDicObs) in
                print("innerProvinceDicObs : ",innerProvinceDicObs.count)
                let controller = ArrayChoiceTableViewController(innerProvinceDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self?.provinceModel.type = type
                    self?.ownerVC.selectCity!.text = ""
                    print("State Code : ",innerProvinceDicObs[type]!)
                    //self?.ownerVC.currentStateCodeObs.accept(innerProvinceDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                Spinner.stop()
                //print("Setting controller")
                self?.showPopup(controller, sourceView: sender as! UIView)
                NetworkManager.shared.provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                }, onError: { _ in
                    print("Province Call Raised Error")
                    Spinner.stop()
            }, onCompleted: {
                print("Province Call Completed")
            }, onDisposed: {
            }).disposed(by: myDisposeBag)
    }
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.ownerVC.present(controller, animated: true)
    }
}

class CityStateGenderViewModel : CityStateViewModel {
    init(_ vc : UIViewController & VCWithCityAndStateAndGender){
        super.init(vc)
        self.ownerVC = vc
    }
    var genderModel = genders() {
        didSet {
            updateGender()
            self.ownerVC.view.setNeedsLayout()
        }
    }
    func updateGender(){
        let vc = (self.ownerVC as! VCWithCityAndStateAndGender)
        vc.genderTextField!.text = genderModel.type
        vc.genderTextField!.resignFirstResponder()
    }
}
