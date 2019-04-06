//
//  SepantaGroupsViewController.swift
//  Sepanta
//
//  Created by Iman on 11/17/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire

class SepantaGroupsViewController : UIViewController,UITextFieldDelegate,Storyboarded{
    weak var coordinator : HomeCoordinator?
    var currentStateCodeObs = BehaviorRelay<String>(value : String())
    var currentCityCodeObs = BehaviorRelay<String>(value : String())
    var cityPressed = BehaviorRelay<Bool>(value: false)
    let myDisposeBag  = DisposeBag()
    var groupButtons : SepantaGroupButtons?
    var catagories = [Catagory]()
    @IBOutlet weak var sepantaScrollView: UIScrollView!
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
    @IBAction func menuClicked(_ sender: Any) {

        self.coordinator!.openButtomMenu()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.groupButtons = nil
        self.coordinator!.popOneLevel()
    }
    
    
    func updateProvince(){
        self.selectProvince.text = provinceModel.type
        selectProvince.resignFirstResponder()
    }
    
    func updateCity(){
        self.selectCity.text = cityModel.type
        selectCity.resignFirstResponder()
    }
    
  
    @IBAction func cityPressed(_ sender: Any) {
        cityPressed.accept(true)
        cityPressed.accept(false)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectProvince || textField == selectCity {
            return false
        } else {
            return true
        }
    }

    @IBAction func provincePressed(_ sender: Any) {
        Spinner.start()
        NetworkManager.shared.run(API: "category-state-list",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil)
    }
    
    override func viewDidLoad() {
        //print("VL SepantaGroup self.coordinator : ",self.coordinator ?? "nil")
        super.viewDidLoad()
        NetworkManager.shared.provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
        NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
        definesPresentationContext = true
        selectCity.delegate = self
        selectProvince.delegate = self
        fetchAllCatagories()
        
       // self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
        registerProvinceChangeListener()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         //self.groupButtons = nil
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
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
