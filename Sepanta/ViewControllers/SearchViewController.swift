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
    var disposeList = [Disposable]()
    var keyword : String?
    @IBOutlet weak var searchText: CustomSearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    @IBAction func returnOnKeyboardTapped(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }

    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
        NetworkManager.shared.shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
    }

    @IBAction func BackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        self.view.endEditing(true)
        self.coordinator!.popHome()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        callNewSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func bindToTableView() {
        searchResultTableView.tableFooterView = UIView()
        let searchDisp = self.searchText.rx.controlEvent([.editingChanged])
            .asObservable()
            .throttle(3, scheduler: MainScheduler.instance)
            .subscribe({ [unowned self] _ in
                //print("My text : \(self.searchText.text ?? "")")
                if self.searchText.text?.count == 0 {
                    NetworkManager.shared.shopSearchResultObs.accept([ShopSearchResult]())
                }else{
                    self.callNewSearch()
                }
            })
        searchDisp.disposed(by: myDisposeBag)
        disposeList.append(searchDisp)

        let resultDisp = NetworkManager.shared.shopSearchResultObs.bind(to: searchResultTableView.rx.items(cellIdentifier: "SearchCell")) { row, aShopSearchResult, cell in
            if let aCell = cell as? SearchCell {
                aCell.shopLabel.text = aShopSearchResult.shop_name
                self.searchResultTableView.rowHeight = UIScreen.main.bounds.height/9
            }            
        }
        resultDisp.disposed(by: myDisposeBag)
        disposeList.append(resultDisp)
        
        let selectDisp = searchResultTableView.rx.modelSelected(ShopSearchResult.self)
            .subscribe(onNext: { [unowned self] aShopSearchResult in
                //print("*** Getting Profile for Shop Result : ", aShopSearchResult)
                guard aShopSearchResult.user_id != 0 else {
                    self.alert(Message: "اظلاعات این فروشگاه کامل نیست")
                    return
                }
                self.view.endEditing(true)
                let ashop = Shop(shop_id: aShopSearchResult.shop_id, user_id: aShopSearchResult.user_id, shop_name: aShopSearchResult.shop_name, shop_off: nil, lat: nil, lon: nil, image: nil, rate: nil,rate_count: 0, follower_count: nil, created_at: nil)
                self.coordinator!.pushShop(Shop: ashop)
            })
        selectDisp.disposed(by: myDisposeBag)
        disposeList.append(selectDisp)
    }
    
    
    func callNewSearch(){
        guard self.searchText.text != nil &&  self.searchText.text != "" else { return }
        let searchText = self.searchText.text!.CRC()
        let aParameter = ["shop_name":searchText]
        NetworkManager.shared.run(API: "search-shops", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
    }
    
    func loadData(){
        self.searchText.text = self.keyword ?? ""
        callNewSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        searchResultTableView.keyboardDismissMode = .onDrag
        searchResultTableView.rowHeight = self.view.frame.height * 0.08
        loadData()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindToTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkManager.shared.postDetailObs.accept(Post())
    }
}
