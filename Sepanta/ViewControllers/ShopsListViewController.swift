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

class ShopsListViewController: UIViewControllerWithErrorBar, Storyboarded, ShopListOwners, UITableViewDelegate,UITextFieldDelegate {
    var dataSource: RxTableViewSectionedAnimatedDataSource<SectionOfShopData>!
    var myDisposeBag = DisposeBag()
    var shopsObs = BehaviorRelay<[Shop]>(value: [Shop]())
    typealias SortFunction = (Shop, Shop) -> Bool
    typealias SearchFunction = (Shop) -> Bool
    let byOff = "بیشترین تخفیف"
    let byFollower = "بیشترین عضو"
    let byNewest = "جدید ترین"
    let byRate = "محبوب ترین"
    let byName = "نام فروشگاه"
    let searchOption = "جستجو"
    let sortOption = "مرتب سازی با"
    let noFilterOption = "بدون فیلتر"
    var filterIsOpen = false
    var filterView: FilterView!

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
    @IBOutlet weak var headerView: UIView!
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("WILL DISPLAY \(indexPath)")
        if !self.shopDataSource.isFetching && indexPath.row >= (self.shopsObs.value.count - 1) {
            print("Reach to the END", self.shopDataSource.last_page, "   ", self.shopDataSource.page)
            if self.shopDataSource.last_page != nil && self.shopDataSource.last_page == self.shopDataSource.page {
                print("Already at the Last page")
                return
            }
            if self.shopDataSource.last_page == nil {
                print("shopDataSource last_page is nil, pagination not supported here.")
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
        createFilterView()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindToTableView()
        shopDataSource = fetchMechanism(self)

        //let newShopsDataSource = ShopsListDataSource(self)
        //newShopsDataSource.getNewShopsFromServer()
    }
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    @objc func applyFilterTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let aSearchFilter: SearchFunction = {
            (ashop) -> Bool in
            guard (self.filterView.searchFilter.text ?? "").count > 0 else {return true}
            if let shopName = ashop.shop_name {
                let searchSubString = (self.filterView.searchFilter.text ?? "").CRC()
                if (shopName.contains(searchSubString)) { return true} else {return false}
            } else {return false}
        }
        var sortFunc: SortFunction = { (ashop, bshop) in return true}
        if (self.filterView.sortFilter.text ?? "") == byName {
            sortFunc = { (ashop, bshop) in
                if ((ashop.shop_name ?? "") < (bshop.shop_name ?? "")) {return true} else {return false}
            }
        } else if (self.filterView.sortFilter.text ?? "") == byRate {
            sortFunc = { (ashop, bshop) in
                if ((Int(ashop.rate ?? "0") ?? 0) > (Int(bshop.rate ?? "0") ?? 0)) {return true} else {return false}
            }
        } else if (self.filterView.sortFilter.text ?? "") == byOff {
            sortFunc = { (ashop, bshop) in
                if ((Int(ashop.shop_off ?? "0") ?? 0) > (Int(bshop.shop_off ?? "0") ?? 0) ) {return true} else {return false}
            }
        } else if (self.filterView.sortFilter.text ?? "") == byFollower {
            sortFunc = { (ashop, bshop) in
                if ((ashop.follower_count ?? 0) > (bshop.follower_count ?? 0)) {return true} else {return false}
            }
        }
        let aSortedData = SectionOfShopData(original: self.sectionOfShops.value[0], items: self.shopsObs.value, sort: sortFunc, search: aSearchFilter )
        sectionOfShops.accept([aSortedData])
    }
    @objc func sortFilterTapped(_ sender: Any) {
        self.view.endEditing(true)
        let allfilterValues = [byNewest, byName, byRate, byOff, byFollower]
        let controller = ArrayChoiceTableViewController(allfilterValues) { (selectedFilter) in
            self.filterView.sortFilter.text = selectedFilter
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterValues.count*45)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.sortFilter)
    }
    
    @objc func searchFilterTapped(_ sender: Any) {
    }
    
    func createFilterView() {
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        filterView = FilterView(frame: CGRect(x: self.view.frame.width, y: frameOri.y+headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25))
        filterView.isHidden = true
        self.view.addSubview(filterView)
        
        filterView.sortFilter.addTarget(self, action: #selector(sortFilterTapped(_:)), for: .allTouchEvents)
        filterView.sortFilter.text = byRate
        filterView.sortFilter.delegate = self
        
        //filterView.searchFilter.addTarget(self, action: #selector(searchFilterTapped(_:)), for: .allTouchEvents)
        filterView.searchFilter.delegate = self
        
        filterView.submitButton.addTarget(self, action: #selector(applyFilterTapped), for: .touchUpInside)
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
                //self.groupHeaderTopCons.constant = 0
            }
        } else {
            filterView.isHidden = false
            //self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
            self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
            
            UIView.animate(withDuration: 1.0) {
                self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
                //self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
                //self.view.layoutIfNeeded()
                //self.filterView.filterType.text = self.searchOption
            }
            
        }
        filterIsOpen = !filterIsOpen
    }
}
