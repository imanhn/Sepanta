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
import Alamofire
import AlamofireImage

class ShopCell : UITableViewCell {
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopFollowers: UILabel!
    @IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    
}

class GroupViewController :  UIViewControllerWithErrorBar,UITextFieldDelegate,Storyboarded{
    weak var coordinator : HomeCoordinator?
    let myDisposeBag  = DisposeBag()
    //var shops : BehaviorRelay<[Shop]> = BehaviorRelay(value: [])
    var filterIsOpen = false
    var selectedCity : String?
    var selectedState : String?
    var filterView : FilterView!
    var selectedFilterType : String?
    var selectedFilterValue : String?
    var newShopsDataSource : ShopsListDataSource!
    @IBOutlet weak var groupHeaderTopCons: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var groupLogoImage: UIImageView!
    @IBOutlet weak var shopTable: UITableView!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    var currentGroupImage = UIImage()
    var catagoryId = Int()
    var currentGroupName = String()
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("EDIT : ",textField.tag,"  ",  selectedFilterType )
        print(textField.tag == 2 ,"  ",selectedFilterType == "جستجو" )
        if textField.tag == 2 && selectedFilterType == "جستجو" {
            return true
        }else{
            return false
        }
    }
    
    @objc func filterValueTapped(_ sender: Any) {
        if selectedFilterType == "جستجو" {
            return
        }
        let allfilterValues = ["محبوب ترین",
                          "بیشترین تخفیف",
                          "حروف الفبا",
                          "جدید ترین"
]
        let controller = ArrayChoiceTableViewController(allfilterValues) {
            (selectedFilter) in
            self.selectedFilterValue = selectedFilter
            self.filterView.filterValue.text = selectedFilter
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterValues.count*60)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.filterValue)
    }
    
    @objc func filterTypeTapped(_ sender : Any){
        let allfilterValues = ["فیلتر بر اساس","جستجو"
        ]
        let controller = ArrayChoiceTableViewController(allfilterValues) {
            (selectedFilter) in
            self.view.endEditing(true)
            self.selectedFilterType = selectedFilter
            self.filterView.filterType.text = selectedFilter
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterValues.count*60)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.filterValue)
    }
    
    func createFilterView(){
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        filterView = FilterView(frame: CGRect(x: self.view.frame.width, y: frameOri.y+headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25))
        filterView.isHidden = true
        self.view.addSubview(filterView)
        filterView.filterValue.addTarget(self, action: #selector(filterValueTapped(_:)), for: .allTouchEvents)
        filterView.filterType.tag = 1
        filterView.filterValue.tag = 2
        filterView.filterType.addTarget(self, action: #selector(filterTypeTapped(_:)), for: .allTouchEvents)
        filterView.filterValue.delegate = self
        filterView.filterType.delegate = self
        filterView.submitButton.addTarget(self, action: #selector(doFilterTapped), for: .touchUpInside)
    }
    @objc func doFilterTapped(_ sender : UIButton){
    
    }
    @IBAction func filterTapped(_ sender: Any) {
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        if filterIsOpen {
            self.groupHeaderTopCons.constant = 0
            self.filterView.frame = CGRect(x: self.view.frame.width, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }else{
            filterView.isHidden = false
            
            self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
            UIView.animate(withDuration: 0.5) {
                self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
                self.view.layoutIfNeeded()
            }

        }
        filterIsOpen = !filterIsOpen
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        newShopsDataSource = nil
        NetworkManager.shared.shopObs = BehaviorRelay<[Any]>(value: [Any]())
        coordinator!.popOneLevel()
        
    }
    
    @IBAction func gotoHomePage(_ sender: Any) {
        coordinator!.popHome()
    }

    @IBAction func openButtomMenu(_ sender: Any) {
        self.coordinator?.openButtomMenu()
    }
    
    func updateGroupHeaders(){
        self.HeaderLabel.text = currentGroupName
        self.groupLabel.text = currentGroupName
        self.groupLogoImage.image = currentGroupImage
        self.groupLogoImage.contentMode = .scaleAspectFit
    }
    

    func bindToTableView() {
        NetworkManager.shared.shopObs.bind(to: shopTable.rx.items(cellIdentifier: "cell")) { row, aShopAsAny, cell in
            if let aCell = cell as? ShopCell {
                let model = aShopAsAny as! Shop
                aCell.shopName.text = model.shop_name
                let persianDiscount :String = "\(model.shop_off ?? 0)".toPersianNumbers()
                aCell.discountPercentage.text = persianDiscount+"%"
                let persianFollowers :String = "\(model.follower_count ?? 0)".toPersianNumbers()
                aCell.shopFollowers.text = persianFollowers
                let persianRate :String = (model.rate ?? "0").toPersianNumbers()
                let rate : Float = Float(model.rate ?? "0.0") ?? 0
                aCell.rateLabel.text = "("+persianRate+")"
                if rate > 0.5 {aCell.star1.image = UIImage(named: "icon_star_on")}
                if rate > 1.5 {aCell.star2.image = UIImage(named: "icon_star_on")}
                if rate > 2.5 {aCell.star3.image = UIImage(named: "icon_star_on")}
                if rate > 3.5 {aCell.star4.image = UIImage(named: "icon_star_on")}
                if rate > 4.5 {aCell.star5.image = UIImage(named: "icon_star_on")}
                if let shopImage = aCell.shopImage{
                    //print("NetworkManager.shared.websiteRootAddress : ",NetworkManager.shared.websiteRootAddress)
                    //print("SlidesAndPaths.shared.path_profile_image : ",SlidesAndPaths.shared.path_profile_image)
                    //print("model.image : ",model.image)
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.image ?? ""))
                    {
                        //print("imageURL : ",imageUrl.absoluteString)
                        shopImage.setImageFromCache(PlaceHolderName :"logo_shape_in", Scale : 0.8 ,ImageURL : imageUrl ,ImageName : (model.image ?? ""))
                    }else{
                        print("model.image path could not be cast to URL  : ",model.image ?? "(model.image is nil)")
                        
                    }
                }
                
            
            }
            }.disposed(by: myDisposeBag)
        
        shopTable.rx.modelSelected(Shop.self)
            .subscribe(onNext: { [unowned self] selectedShop in
                //print("Pushing ShopVC with : ", selectedShop)
                self.coordinator!.pushShop(Shop: selectedShop)
            }).disposed(by: myDisposeBag)
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        print("Going for reload in GroupViewController")
        super.ReloadViewController(sender)
        newShopsDataSource = ShopsListDataSource(self)
        newShopsDataSource.getShopListForACatagory(Catagory: "\(self.catagoryId)", State: selectedState, City: selectedCity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFilterView()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        newShopsDataSource = ShopsListDataSource(self)
        newShopsDataSource.getShopListForACatagory(Catagory: "\(self.catagoryId)", State: selectedState, City: selectedCity)
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
