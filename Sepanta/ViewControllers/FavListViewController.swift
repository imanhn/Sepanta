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
import RxDataSources
import Alamofire
import AlamofireImage


class FavListViewController :  UIViewControllerWithErrorBar,XIBView,ShopListOwners{
    var dataSource: RxTableViewSectionedAnimatedDataSource<SectionOfShopData>!
    var shopsObs = BehaviorRelay<[Shop]>(value: [Shop]())
    var disposeList = [Disposable]()
    var myDisposeBag = DisposeBag()
    
    var sectionOfShops = BehaviorRelay<[SectionOfShopData]>(value: [SectionOfShopData]())

    var maximumFontSize : CGFloat!
    var fetchMechanism : dataSourceFunc!
    var shopDataSource : ShopsListDataSource!
    weak var coordinator : HomeCoordinator?
    
    //var newShopsDataSource : ShopsListDataSource!
    @IBOutlet weak var headerLabel: UILabel!
    var headerLabelToSet : String = "فروشگاه ها"
    @IBOutlet weak var shopTable: UITableView!

    
    @objc override func willPop() {
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
    }
    
}








