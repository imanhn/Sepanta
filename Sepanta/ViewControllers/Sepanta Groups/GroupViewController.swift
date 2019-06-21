//
//  GroupViewController.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import AlamofireImage


class ShopCell : UITableViewCell {
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopFollowers: UILabel!
    //@IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var offImage: UIImageView!
    
}

class GroupViewController :  UIViewControllerWithErrorBar,UITextFieldDelegate,Storyboarded,ShopListOwners{
    var myDisposeBag = DisposeBag()
    var fetchMechanism : dataSourceFunc!
    var shopsObs = BehaviorRelay<[Shop]>(value: [Shop]())
    typealias SortFunction = (Shop,Shop)-> Bool
    typealias SearchFunction = (Shop)-> Bool
    var maximumFontSize : CGFloat!
    var dataSource : RxTableViewSectionedAnimatedDataSource<SectionOfShopData>!
    var disposeList : [Disposable] = [Disposable]()
    weak var coordinator : HomeCoordinator?
    let byOff = "بیشترین تخفیف"
    let byFollower = "بیشترین عضو"
    let byNewest = "جدید ترین"
    let byRate = "محبوب ترین"
    let byName = "نام فروشگاه"
    let searchOption = "جستجو"
    let sortOption = "مرتب سازی با"
    let noFilterOption = "بدون فیلتر"
    var sectionOfShops = BehaviorRelay<[SectionOfShopData]>(value: [SectionOfShopData]())
    //var shops : BehaviorRelay<[Shop]> = BehaviorRelay(value: [])
    var filterIsOpen = false
    var selectedCity : String?
    var selectedState : String?
    var selectedCityStr : String?
    var selectedStateStr : String?
    var filterView : FilterView!
    var newShopsDataSource : ShopsListDataSource!
    @IBOutlet weak var groupHeaderTopCons: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var groupLogoImage: UIImageView!
    @IBOutlet weak var shopTable: UITableView!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var locationLabelButton: UIButton!
    @IBOutlet weak var locationViewSize: NSLayoutConstraint!
    
    var currentGroupImage = UIImage()
    var catagoryId = Int()
    var currentGroupName = String()
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("EDIT : ",textField.tag,"  ",  selectedFilterType )
        //print(textField.tag == 2 ,"  ",selectedFilterType == searchOption )
        if textField.tag == 11 { // FilterView.sortFilter.tag = 11
            return false
        }else{
            return true
        }
    }
    
    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
        newShopsDataSource = nil
        dataSource = nil
        NetworkManager.shared.shopObs = BehaviorRelay<[Shop]>(value: [Shop]())
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        coordinator!.popOneLevel()
    }
    
    @IBAction func gotoHomePage(_ sender: Any) {
        coordinator!.popHome()
    }

    @IBAction func openButtomMenu(_ sender: Any) {
        self.coordinator?.openButtomMenu()
    }
    
    func pushAShop(_ selectedShop : Shop){
        self.coordinator!.pushShop(Shop: selectedShop)
    }
    
    func updateGroupHeaders(){
        self.HeaderLabel.text = currentGroupName
        self.groupLabel.text = currentGroupName
        self.groupLogoImage.image = currentGroupImage
        self.groupLogoImage.contentMode = .scaleAspectFit
        let locationText = (self.selectedCityStr ?? self.selectedStateStr) ?? "کل کشور"
        self.locationLabelButton.setTitle(locationText, for: .normal)
    }
    

    @objc override func ReloadViewController(_ sender:Any) {
        print("Going for reload in GroupViewController")
        super.ReloadViewController(sender)
        newShopsDataSource = ShopsListDataSource(self)
        let aparam = newShopsDataSource.buildParameters(Catagory: "\(self.catagoryId)", State: selectedState, City: selectedCity)
        newShopsDataSource.getShops(Api: "category-shops-list", Method: HTTPMethod.post, Parameters: aparam)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFilterView()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        newShopsDataSource = ShopsListDataSource(self)
        let aparam = newShopsDataSource.buildParameters(Catagory: "\(self.catagoryId)", State: selectedState, City: selectedCity)
        newShopsDataSource.getShops(Api: "category-shops-list", Method: HTTPMethod.post, Parameters: aparam)
        bindToTableView()
        updateGroupHeaders()
    }
       
    
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    
}


