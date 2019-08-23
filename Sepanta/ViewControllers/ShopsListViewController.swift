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

class ShopsListViewController: UIViewControllerWithErrorBar, Storyboarded, ShopListOwners, UITableViewDelegate {
    var dataSource: RxTableViewSectionedAnimatedDataSource<SectionOfShopData>!
    var myDisposeBag = DisposeBag()
    var shopsObs = BehaviorRelay<[Shop]>(value: [Shop]())
    //typealias DataSourceFunc = (ShopsListViewController) -> ShopsListDataSource
    var fetchMechanism: DataSourceFunc!
    var shopDataSource: ShopsListDataSource!
    var sectionOfShops = BehaviorRelay<[SectionOfShopData]>(value: [SectionOfShopData]())
    var disposeList = [Disposable]()
    weak var coordinator: HomeCoordinator?
    var maximumFontSize: CGFloat!
    @IBOutlet weak var headerLabel: UILabel!
    var headerLabelToSet: String = "فروشگاه ها"
    @IBOutlet weak var shopTable: UITableView!

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("WILL DISPLAY \(indexPath)")
        if !self.shopDataSource.isFetching && indexPath.row >= (self.shopsObs.value.count - 1) {
            print("Reach to the END", self.shopDataSource.last_page, "   ", self.shopDataSource.page)
            if self.shopDataSource.last_page != nil && self.shopDataSource.last_page == self.shopDataSource.page {
                print("Already at the Last page")
                return
            }

            let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                spinner.activityIndicatorViewStyle = .gray
            spinner.startAnimating()
            tableView.tableFooterView = spinner
            self.shopDataSource.isFetching = true
            shopDataSource.fetchNextPage()
        }
    }

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

    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
        shopDataSource = fetchMechanism(self)
        //newShopsDataSource.getNewShopsFromServer()
    }

    func pushAShop(_ selectedShop: Shop) {
        self.coordinator!.pushShop(Shop: selectedShop)
    }

    func setHeaderName() {
        self.headerLabel.text = self.headerLabelToSet
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shopTable.delegate = self
        setHeaderName()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindToTableView()
        shopDataSource = fetchMechanism(self)

        //let newShopsDataSource = ShopsListDataSource(self)
        //newShopsDataSource.getNewShopsFromServer()
    }

}
