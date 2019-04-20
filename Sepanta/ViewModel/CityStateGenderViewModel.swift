//
//  CityStateGenderViewModel.swift
//  Sepanta
//
//  Created by Iman on 1/31/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

protocol VCWithCityAndState {
    var selectCity : UnderLinedSelectableTextField {set get}
    var selectProvince : UnderLinedSelectableTextField {set get}
}

protocol VCWithCityAndStateAndGender : VCWithCityAndState{
    var genderTextField : UnderLinedSelectableTextField {set get}
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
        self.ownerVC.selectProvince.text = provinceModel.type
        self.ownerVC.selectProvince.resignFirstResponder()
    }
    func updateCity(){
        self.ownerVC.selectCity.text = cityModel.type
        self.ownerVC.selectCity.resignFirstResponder()
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
        vc.genderTextField.text = genderModel.type
        vc.genderTextField.resignFirstResponder()
    }
}
