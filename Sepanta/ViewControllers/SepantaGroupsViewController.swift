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

class SepantaGroupsViewController : UIViewControllerWithCoordinator,UITextFieldDelegate,Storyboarded{
    var currentStateCodeObs = BehaviorRelay<String>(value : String())
    var currentCityCodeObs = BehaviorRelay<String>(value : String())
    var myDisposeBag = DisposeBag()
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
        let alert = UIAlertController(title: "توجه", message: "منو باز شد", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بلی", style: .default))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        guard let acoordinator = coordinator as? HomeCoordinator else {
            return
        }
        acoordinator.start()
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
        let parameters = [
            "state code": self.currentStateCodeObs.value
        ]
        self.view.endEditing(true)
        (sender as AnyObject).resignFirstResponder()
        let queryString = "?state%20code=\(self.currentStateCodeObs.value)"
        Spinner.start()
        NetworkManager.shared.run(API: "get-state-and-city",QueryString: queryString, Method: HTTPMethod.post, Parameters: parameters, Header: nil)
        NetworkManager.shared.cityDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerCityDicObs) in
                let controller = ArrayChoiceTableViewController(innerCityDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self?.cityModel.type = type
                    print("City Code : ",innerCityDicObs[type]!)
                    self?.currentCityCodeObs.accept(innerCityDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                Spinner.stop()
                print("Setting controller")
                self?.showPopup(controller, sourceView: sender as! UIView)
                NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                }, onError: { _ in
                    Spinner.stop()
            }, onCompleted: {
            }, onDisposed: {
            }).disposed(by: myDisposeBag)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectProvince || textField == selectCity {
            return false
        } else {
            return true
        }
    }

    @IBAction func provincePressed(_ sender: Any) {
        let headers = [
//            "Accept": "application/json",
            "Authorization" : "Bearer "+LoginKey.shared.token
            //"Content-Type":"application/x-www-form-urlencoded"
        ]
        print("Catagory Headers : ",headers)
        selectProvince.isEnabled = false
        selectProvince.isEnabled = true
        Spinner.start()
        NetworkManager.shared.run(API: "category-state-list",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: headers)
        NetworkManager.shared.provinceDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerProvinceDicObs) in
                print("innerProvinceDicObs : ",innerProvinceDicObs.count)
                let controller = ArrayChoiceTableViewController(innerProvinceDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self?.provinceModel.type = type
                    self?.selectCity.text = ""
                    print("Catagory State Code : ",innerProvinceDicObs[type]!)
                    self?.currentStateCodeObs.accept(innerProvinceDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                Spinner.stop()
                print("Setting controller")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        selectCity.delegate = self
        selectProvince.delegate = self
       // self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        _ = SepantaGroupButtons(self)
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
