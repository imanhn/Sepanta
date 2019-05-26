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
    @IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
}

class GroupViewController :  UIViewControllerWithErrorBar,UITextFieldDelegate,Storyboarded{
    typealias SortFunction = (Shop,Shop)-> Bool
    var dataSource : RxTableViewSectionedAnimatedDataSource<SectionOfShopData>!
    var disposeList : [Disposable] = [Disposable]()
    weak var coordinator : HomeCoordinator?
    let byOff = "بیشترین تخفیف"
    let byFollower = "بیشترین عضو"
    let byNewest = "جدید ترین"
    let byRate = "بیشترین امتیاز"
    let byName = "نام فروشگاه"
    let searchOption = "جستجو"
    let sortOption = "مرتب سازی با"
    let noFilterOption = "بدون فیلتر"
    let myDisposeBag  = DisposeBag()
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
    
    var currentGroupImage = UIImage()
    var catagoryId = Int()
    var currentGroupName = String()
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("EDIT : ",textField.tag,"  ",  selectedFilterType )
        //print(textField.tag == 2 ,"  ",selectedFilterType == searchOption )
        if textField.tag == 2 && self.filterView.filterType.text == searchOption {
            return true
        }else{
            return false
        }
    }
    
    @objc func filterValueTapped(_ sender: Any) {
        if self.filterView.filterType.text == searchOption || self.filterView.filterType.text == noFilterOption {
            return
        }
        let allfilterValues = [byNewest,byName,byRate,byOff,byFollower]
        let controller = ArrayChoiceTableViewController(allfilterValues) {
            (selectedFilter) in
            if selectedFilter == self.noFilterOption {
                self.filterView.filterType.isEnabled = false
            }else{
                self.filterView.filterType.isEnabled = true
            }
            self.filterView.filterValue.text = selectedFilter
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterValues.count*45)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.filterValue)
    }
    
    @objc func filterTypeTapped(_ sender : Any){
        let allfilterTypes = [searchOption,sortOption,noFilterOption]
        let controller = ArrayChoiceTableViewController(allfilterTypes) {
            (selectedFilter) in
            self.view.endEditing(true)
            self.filterView.filterType.text = selectedFilter
            if selectedFilter == self.searchOption || selectedFilter == self.noFilterOption{
                self.filterView.filterValue.text = ""
            }else if selectedFilter == self.sortOption {
                self.filterView.filterValue.text = self.byName
            }
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterTypes.count*45)
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
        self.view.endEditing(true)
        if self.filterView.filterType.text == searchOption {
            let aFilteredData = SectionOfShopData(original: self.sectionOfShops.value[0], items: NetworkManager.shared.shopObs.value, filter: {
                (ashop)->Bool in
                guard (self.filterView.filterValue.text ?? "").count > 0 else{return true}
                if let shopName = ashop.shop_name {
                    let searchSubString = (self.filterView.filterValue.text ?? "").CRC()
                    if (shopName.contains(searchSubString)) { return true}else{return false}
                }else{return false}
            })
            sectionOfShops.accept([aFilteredData])
        }else if ((self.filterView.filterValue.text ?? "") == byNewest) || self.filterView.filterType.text == noFilterOption {
            let aNormalList = SectionOfShopData(original: self.sectionOfShops.value[0], items: NetworkManager.shared.shopObs.value)
            sectionOfShops.accept([aNormalList])
        }else if self.filterView.filterType.text == sortOption {
            var sortFunc : SortFunction = { (ashop,bshop) in return true}
            if (self.filterView.filterValue.text ?? "") == byName {
                sortFunc = { (ashop,bshop) in
                    if ((ashop.shop_name ?? "") < (bshop.shop_name ?? "")) {return true}else{return false}
                }
            }else if (self.filterView.filterValue.text ?? "") == byRate {
                sortFunc = { (ashop,bshop) in
                    if ((Int(ashop.rate ?? "0") ?? 0) > (Int(bshop.rate ?? "0") ?? 0)) {return true}else{return false}
                }
            }else if (self.filterView.filterValue.text ?? "") == byOff {
                sortFunc = { (ashop,bshop) in
                    if ((ashop.shop_off ?? 0) > (bshop.shop_off ?? 0)) {return true}else{return false}
                }
            }else if (self.filterView.filterValue.text ?? "") == byFollower {
                sortFunc = { (ashop,bshop) in
                    if ((ashop.follower_count ?? 0) > (bshop.follower_count ?? 0)) {return true}else{return false}
                }
            }
            let aSortedData = SectionOfShopData(original: self.sectionOfShops.value[0], items: NetworkManager.shared.shopObs.value, sort: sortFunc)
            sectionOfShops.accept([aSortedData])

        }
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        if filterIsOpen {
            //self.groupHeaderTopCons.constant = 0
            self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
            filterView.isHidden = true
            
            UIView.animate(withDuration: 1.0) {
                self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
                //self.view.layoutIfNeeded()
                self.groupHeaderTopCons.constant = 0
            }
        }else{
            filterView.isHidden = false
            //self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
            self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
            
            UIView.animate(withDuration: 1.0) {
                self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
                self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
                //self.view.layoutIfNeeded()
                //self.filterView.filterType.text = self.searchOption
            }

        }
        filterIsOpen = !filterIsOpen
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
    
    func updateGroupHeaders(){
        self.HeaderLabel.text = currentGroupName
        self.groupLabel.text = currentGroupName
        self.groupLogoImage.image = currentGroupImage
        self.groupLogoImage.contentMode = .scaleAspectFit
        let locationText = (self.selectedCityStr ?? self.selectedStateStr) ?? "کل کشور"
        self.locationLabelButton.setTitle(locationText, for: .normal)
    }
    

    func bindToTableView() {
        NetworkManager.shared.shopObs
            .subscribe(onNext: { shops in
                let initsec = SectionOfShopData(original: SectionOfShopData(header: "Header", items: [Shop]()), items: shops)
                self.sectionOfShops.accept([initsec])
                self.shopTable.reloadData()
            }).disposed(by: myDisposeBag)
        
        dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfShopData>(configureCell: { dataSource, tableView, indexPath, item in
            //let row = indexPath.row
            let model = item
            let cell = self.shopTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var returningCell : ShopCell!
            if let aCell = cell as? ShopCell {
                aCell.shopName.text = model.shop_name
                let persianDiscount :String = "\(model.shop_off ?? 0)".toPersianNumbers()
                aCell.discountPercentage.text = persianDiscount+"%"
                let persianFollowers :String = "\(model.follower_count ?? 0)".toPersianNumbers()
                aCell.shopFollowers.text = persianFollowers
                let persianRate :String = "\(model.rate_count ?? 0)".toPersianNumbers()
                let rate : Float = Float(model.rate ?? "0.0") ?? 0
                aCell.rateLabel.text = "("+persianRate+")"                
                aCell.star1.image = UIImage(named: "icon_star_gray")
                aCell.star2.image = UIImage(named: "icon_star_gray")
                aCell.star3.image = UIImage(named: "icon_star_gray")
                aCell.star4.image = UIImage(named: "icon_star_gray")
                aCell.star5.image = UIImage(named: "icon_star_gray")
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
                returningCell = aCell
            }
            return returningCell ?? cell
            
        }) // of datasource
        
        //NetworkManager.shared.shopObs
        let aSectionShopDisp = sectionOfShops.bind(to: shopTable.rx.items(dataSource: dataSource))
        aSectionShopDisp.disposed(by: myDisposeBag)
        disposeList.append(aSectionShopDisp)
        
 
        let aModelSelectDisp = shopTable.rx.modelSelected(Shop.self)
            .subscribe(onNext: { [unowned self] selectedShop in
                //print("Pushing ShopVC with : ", selectedShop)
                self.coordinator!.pushShop(Shop: selectedShop)
            })
        aModelSelectDisp.disposed(by: myDisposeBag)
        disposeList.append(aModelSelectDisp)
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


