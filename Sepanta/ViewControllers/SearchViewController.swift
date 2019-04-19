//
//  Search2ViewController.swift
//  Sepanta
//
//  Created by Iman on 1/28/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

class SearchCell : UITableViewCell {
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var showShopButton: UIButton!
}

class SearchViewController : UIViewControllerWithErrorBar{
    weak var coordinator : HomeCoordinator?
    var myDisposeBag = DisposeBag()
    var keyword : String?
    @IBOutlet weak var searchText: CustomSearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    @IBAction func returnOnKeyboardTapped(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func BackTapped(_ sender: Any) {
        NetworkManager.shared.shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        NetworkManager.shared.shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
        self.coordinator!.popHome()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func bindToTableView() {
        self.searchText.rx.controlEvent([.editingChanged])
            .asObservable()
            .throttle(3, scheduler: MainScheduler.instance)
            .subscribe({ [unowned self] _ in
                self.callNewSearch()
                //print("My text : \(self.searchText.text ?? "")")
            }).disposed(by: myDisposeBag)

        NetworkManager.shared.shopSearchResultObs.bind(to: searchResultTableView.rx.items(cellIdentifier: "SearchCell")) { row, aShopSearchResult, cell in
            if let aCell = cell as? SearchCell {
                let model = aShopSearchResult as! ShopSearchResult
                aCell.shopLabel.text = model.shop_name
            }
            }.disposed(by: myDisposeBag)
        
        searchResultTableView.rx.modelSelected(ShopSearchResult.self)
            .subscribe(onNext: { [unowned self] aShopSearchResult in
                //print("*** Getting Profile for Shop Result : ", aShopSearchResult)
                guard aShopSearchResult.user_id != 0 else {
                    self.alert(Message: "اظلاعات این فروشگاه کامل نیست")
                    return
                }
                let ashop = Shop(shop_id: aShopSearchResult.shop_id, user_id: aShopSearchResult.user_id, shop_name: aShopSearchResult.shop_name, shop_off: nil, lat: nil, long: nil, image: nil, rate: nil, follower_count: nil, created_at: nil)
                self.coordinator!.pushShop(Shop: ashop)
            }).disposed(by: myDisposeBag)
    }
    
    
    func callNewSearch(){
        if self.searchText.text == "" {return}
        let aParameter = ["shop_name":"\(self.searchText.text ?? "")"]
        NetworkManager.shared.run(API: "search-shops", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
    }
    
    func loadData(){
        self.searchText.text = self.keyword ?? ""
        callNewSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultTableView.rowHeight = self.view.frame.height * 0.08
        loadData()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindToTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkManager.shared.postDetailObs.accept(Post())
    }
}
