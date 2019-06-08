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
import RxDataSources

class NewShopCell : UITableViewCell {
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

class ShopsListViewController :  UIViewControllerWithErrorBar,Storyboarded,ShopListOwners{
    
    
    var myDisposeBag = DisposeBag()
    
    //typealias dataSourceFunc = (ShopsListViewController) -> ShopsListDataSource
    var fetchMechanism : dataSourceFunc!
    var shopDataSource : ShopsListDataSource!
    var sectionOfShops = BehaviorRelay<[SectionOfShopData]>(value: [SectionOfShopData]())
    var disposeList = [Disposable]()
    weak var coordinator : HomeCoordinator?    
    var maximumFontSize : CGFloat!
    @IBOutlet weak var headerLabel: UILabel!
    var headerLabelToSet : String = "فروشگاه ها"
    @IBOutlet weak var shopTable: UITableView!

    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
        shopDataSource = nil
        NetworkManager.shared.shopObs = BehaviorRelay<[Shop]>(value: [Shop]())        
    }

    @IBAction func backTapped(_ sender: Any) {
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
    
    func pushAShop(_ selectedShop: Shop) {
        self.coordinator!.pushShop(Shop: selectedShop)
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







