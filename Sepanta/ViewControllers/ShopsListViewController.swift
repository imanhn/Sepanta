//
//  ShopsListViewController.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class NewShopCell : UITableViewCell {
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

class ShopsListViewController :  UIViewControllerWithErrorBar,Storyboarded{
    typealias dataSourceFunc = (ShopsListViewController) -> ShopsListDataSource
    var fetchMechanism : dataSourceFunc!
    var shopDataSource : ShopsListDataSource!
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    //var newShopsDataSource : ShopsListDataSource!
    @IBOutlet weak var headerLabel: UILabel!
    var headerLabelToSet : String = "فروشگاه ها"
    @IBOutlet weak var shopTable: UITableView!
    
    @IBAction func backTapped(_ sender: Any) {
        shopDataSource = nil
        NetworkManager.shared.shopObs = BehaviorRelay<[Any]>(value: [Any]())
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func menuTapped(_ sender: Any) {
         self.coordinator!.openButtomMenu()
    }
    @IBAction func homeTapped(_ sender: Any) {
        shopDataSource = nil
        self.coordinator!.popHome()
    }

    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        shopDataSource = fetchMechanism(self)
        //newShopsDataSource.getNewShopsFromServer()
    }
    
    func bindToTableView() {
        NetworkManager.shared.shopObs.bind(to: shopTable.rx.items(cellIdentifier: "cell")) { row, aShopAsAny, cell in
            if let aCell = cell as? NewShopCell {
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
    
    func setHeaderName(){
        self.headerLabel.text = self.headerLabelToSet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderName()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindToTableView()
        shopDataSource = fetchMechanism(self)
        
        //let newShopsDataSource = ShopsListDataSource(self)
        //newShopsDataSource.getNewShopsFromServer()
    }
    
}







