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

class SepantaGroupsViewController : UIViewControllerWithErrorBar,UITextFieldDelegate,Storyboarded{
    weak var coordinator : HomeCoordinator?
    var currentStateCodeObs = BehaviorRelay<String>(value : String())
    var currentCityCodeObs = BehaviorRelay<String>(value : String())
    var cityPressed = BehaviorRelay<Bool>(value: false)
    let myDisposeBag  = DisposeBag()
    var groupButtons : SepantaGroupButtons?
    var catagories = [Catagory]()
    var disposableArray = [Disposable]()
    @IBOutlet weak var sepantaScrollView: UIScrollView!
    @IBOutlet weak var selectCity: UnderLinedSelectableTextField!
    @IBOutlet weak var selectProvince: UnderLinedSelectableTextField!

    
    @IBAction func menuClicked(_ sender: Any) {
        self.coordinator!.openButtomMenu()
    }
    @objc override func willPop() {
        self.groupButtons = nil
        disposableArray.forEach{$0.dispose()}
    }

    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func cityPressed(_ sender: Any) {
        let innerCityDicObs = NetworkManager.shared.cityDictionaryObs.value
        let controller = ArrayChoiceTableViewController(innerCityDicObs.keys.sorted(){$0 < $1}) {
            (selectedCityStr) in
            self.selectCity.text = selectedCityStr
            self.currentCityCodeObs.accept(innerCityDicObs[selectedCityStr]!)
        }
        controller.preferredContentSize = CGSize(width: 250, height: innerCityDicObs.count*60)
        Spinner.stop()
        self.showPopup(controller, sourceView: self.selectCity!)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

    @IBAction func provincePressed(_ sender: Any) {
        NetworkManager.shared.run(API: "category-state-list",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        selectProvince.text = ""
        selectCity.text = ""
        fetchCatagories(nil)
    }
    
    override func viewDidLoad() {
        //print("VL SepantaGroup self.coordinator : ",self.coordinator ?? "nil")
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        NetworkManager.shared.provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
        NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
        definesPresentationContext = true
        selectCity.delegate = self
        selectProvince.delegate = self
        subscribeToUpdateCategories()
        subscribeToStateChange()
        fetchCatagories(nil)
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
    
}
