//
//  FavListViewController.swift
//  Sepanta
//
//  Created by Iman on 2/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

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

class FavShopCell : UITableViewCell {
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var discountPercentage: UILabel!
}

class FavListViewController :  UIViewControllerWithErrorBar,XIBView{
    typealias dataSourceFunc = (FavListViewController) -> FavListDataSource
    var fetchMechanism : dataSourceFunc!
    var shopDataSource : FavListDataSource!
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    //var newShopsDataSource : ShopsListDataSource!
    @IBOutlet weak var headerLabel: UILabel!
    var headerLabelToSet : String = "فروشگاه ها"
    @IBOutlet weak var shopTable: UITableView!
    
    @IBAction func backTapped(_ sender: Any) {
        shopDataSource = nil
        NetworkManager.shared.shopObs = BehaviorRelay<[Shop]>(value: [Shop]())
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
        NetworkManager.shared.favShopObs.bind(to: shopTable.rx.items(cellIdentifier: "cell")) { row, model, cell in
            if let aCell = cell as? FavShopCell {
                //let model = aShopAsAny as! Shop
                aCell.shopName.text = model.shop_name
                let persianDiscount :String = "\(model.shop_off ?? 0)".toPersianNumbers()
                aCell.discountPercentage.text = persianDiscount+"%"
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
    }
    
}








