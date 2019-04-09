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
    var selectedCity : String?
    var selectedState : String?
    var newShopsDataSource : ShopsListDataSource!
    
    @IBOutlet weak var groupLogoImage: UIImageView!
    @IBOutlet weak var shopTable: UITableView!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    var currentGroupImage = UIImage()
    var catagoryId = Int()
    var currentGroupName = String()
    
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
                aCell.shopName.text = model.name
                let persianDiscount :String = "\(model.dicount)".toPersianNumbers()
                aCell.discountPercentage.text = persianDiscount+"%"
                let persianFollowers :String = "\(model.followers)".toPersianNumbers()
                aCell.shopFollowers.text = persianFollowers
                let persianRate :String = "\(model.stars)".toPersianNumbers()
                aCell.rateLabel.text = "("+persianRate+")"
                if model.stars > 0.5 {aCell.star1.image = UIImage(named: "icon_star_on")}
                if model.stars > 1.5 {aCell.star2.image = UIImage(named: "icon_star_on")}
                if model.stars > 2.5 {aCell.star3.image = UIImage(named: "icon_star_on")}
                if model.stars > 3.5 {aCell.star4.image = UIImage(named: "icon_star_on")}
                if model.stars > 4.5 {aCell.star5.image = UIImage(named: "icon_star_on")}
                if let shopImage = aCell.shopImage{
                    //print("NetworkManager.shared.websiteRootAddress : ",NetworkManager.shared.websiteRootAddress)
                    //print("SlidesAndPaths.shared.path_profile_image : ",SlidesAndPaths.shared.path_profile_image)
                    //print("model.image : ",model.image)
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+model.image)
                    {
                        //print("imageURL : ",imageUrl.absoluteString)
                        shopImage.setImageFromCache(PlaceHolderName :"logo_shape_in", Scale : 0.8 ,ImageURL : imageUrl ,ImageName : model.image)
                    }else{
                        print("model.image path could not be cast to URL  : ",model.image)
                        
                    }
                }
                
            
            }
            }.disposed(by: myDisposeBag)
        
        shopTable.rx.modelSelected(Shop.self)
            .subscribe(onNext: { [unowned self] selectedShop in
                print("Pushing ShopVC with : ", selectedShop)
                self.coordinator!.pushShop(Shop: selectedShop)
            })
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        newShopsDataSource = ShopsListDataSource(self)
        newShopsDataSource.getShopListForACatagory(Catagory: "\(self.catagoryId)", State: selectedState, City: selectedCity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newShopsDataSource = ShopsListDataSource(self)
        newShopsDataSource.getShopListForACatagory(Catagory: "\(self.catagoryId)", State: selectedState, City: selectedCity)
        bindToTableView()
        updateGroupHeaders()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //shops.accept([])
        //shopTable.reloadData()
        newShopsDataSource = nil
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func gotoHomePage(_ sender: Any) {
        coordinator!.popHome()        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        coordinator!.popOneLevel()

    }
    
}
