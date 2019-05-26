//
//  ShopViewController.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage


class ShopViewController :  UIViewControllerWithErrorBar,Storyboarded{
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    var shopRateDisp : Disposable!
    var shop : Shop!
    var shopUI : ShopUI!
    //var shopDataSource : ShopDataSource!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    var editShopButton : UIButton!
    @IBOutlet weak var toolbarStack: UIStackView!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopLogo: UIImageView!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var shopTitle: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var shopDescription: UILabel!
    @IBOutlet weak var panelView: TabbedViewWithWhitePanel!
    @IBOutlet weak var PostToolbarView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var offLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var shopLogoTrailing: NSLayoutConstraint!
    @IBOutlet weak var shopLogoShopTitleDistance: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ContactButton: UIButton!
    @IBOutlet weak var PostsButton: UIButton!

    @IBAction func rateTapped(_ sender: Any) {
        
        print("RateTApped : ",shop.shop_id ?? 0)
        let rWidth = (self.view.frame.width * 0.9)
        let rHeight = rWidth / 2
        let xOffset = self.view.frame.width * 0.05
        let yOffset = (self.view.frame.height - rHeight) / 2
        
        let rateViewRect = CGRect(x: xOffset, y: yOffset, width: rWidth, height: rHeight)
        if let ashopID = shop.shop_id  {
            let rateView = RateView(frame: rateViewRect,ShopID: ashopID)
            self.view.addSubview(rateView)
            shopRateDisp = NetworkManager.shared.shopRateObs
                .filter({$0.rate_avg != nil && $0.rate_avg! > 0})
                .subscribe(onNext: { [unowned self] arate in
                    self.updateNewRate(arate)
                    NetworkManager.shared.shopRateObs = BehaviorRelay<Rate>(value: Rate())
                })
            shopRateDisp.disposed(by: myDisposeBag)
            disposeList.append(shopRateDisp)
        }
    }
    
    func updateNewRate(_ aRate : Rate){
        if let rate = aRate.rate_avg {
            self.star1.setImage(UIImage(named: "icon_star_gray"), for: .normal)
            self.star2.setImage(UIImage(named: "icon_star_gray"), for: .normal)
            self.star3.setImage(UIImage(named: "icon_star_gray"), for: .normal)
            self.star4.setImage(UIImage(named: "icon_star_gray"), for: .normal)
            self.star5.setImage(UIImage(named: "icon_star_gray"), for: .normal)
            if rate >= 1 {self.star1.setImage(UIImage(named: "icon_star_on"), for: .normal)}
            if rate >= 2 {self.star2.setImage(UIImage(named: "icon_star_on"), for: .normal)}
            if rate >= 3 {self.star3.setImage(UIImage(named: "icon_star_on"), for: .normal)}
            if rate >= 4 {self.star4.setImage(UIImage(named: "icon_star_on"), for: .normal)}
            if rate >= 5 {self.star5.setImage(UIImage(named: "icon_star_on"), for: .normal)}
        }
        rateLabel.text = "(\(aRate.rate_count ?? 1))"
        self.alert(Message: aRate.message ?? "امتیاز شما ثبت گردید")
        shopRateDisp?.dispose()
    }
    
    @IBAction func showPostsTapped(_ sender: Any) {
        self.panelView.tabJust = .Right
        self.panelView.setNeedsDisplay()
        self.shopUI!.showShopPosts()
    }
    

    @IBAction func showContactTapped(_ sender: Any) {
        self.panelView.tabJust = .Left
        self.panelView.setNeedsDisplay()
        self.shopUI!.showContacts()
    }
    
    @objc override func willPop() {
        shopUI = nil
        NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: Profile())
        NetworkManager.shared.shopFav = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    }

    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        self.coordinator!.pushShopMapOrPopMapVC(self.shop)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        //favButton
        guard self.shop != nil else{
            alert(Message: "اطلاعات فروشگاه ناقص است امکان اضافه به علاقه مندی ها وجود ندارد")
            return
        }
        
        // Toggle Favorite the shop Icon immediately
        if (self.favButton != nil){
            if NetworkManager.shared.shopProfileObs.value.is_favorite != nil{
                if NetworkManager.shared.shopProfileObs.value.is_favorite! {
                    self.favButton.setImage(UIImage(named: "icon_star_fav_gray"), for: .normal)
                }else{
                    self.favButton.setImage(UIImage(named: "icon_star_fav_dark"), for: .normal)
                }
            }
        }
        let aParameter = ["shop_id":"\(self.shop.shop_id ?? 0)"]
        NetworkManager.shared.run(API: "favorite", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        // Update Favorite list
        NetworkManager.shared.run(API: "favorite", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: false)
    }
    
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        getShopFromServer()
    }
    
    func getShopFromServer() {
        NetworkManager.shared.shopProfileObs = BehaviorRelay<Profile>(value: Profile())
        //print("self.shop.user_id : ",self.shop.user_id)
        guard self.shop.user_id != 0 && self.shop.user_id != nil else {
            alert(Message: "اظلاعات این فروشگاه کامل نیست")
            return
        }
        let aParameter = ["user id":"\(self.shop.user_id!)"]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true,TargetObs: "SHOP")
    }
    
    func editAuthorized()-> Bool{
        //print("***Check Authorization : ","\(self.shop.user_id ?? 0)" ,"  ",LoginKey.shared.userID)
        if "\(self.shop.user_id ?? 0)" == LoginKey.shared.userID {
            return true
        }else{
            return false
        }
    }
    
    @objc func gotoEditShop(){
        print("Editing : ",shop)
        self.coordinator!.pushEditShop(Shop : shop)
    }
    
    func changeToShopOwnerIfNeeded() {
        if editAuthorized() {
            self.locationButton.removeFromSuperview()
            self.favButton.removeFromSuperview()
            editShopButton = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            editShopButton.setImage(UIImage(named: "icon_edit"), for: .normal)
            
            editShopButton.addTarget(self, action: #selector(gotoEditShop), for: .touchUpInside)
            toolbarStack.addSubview(editShopButton)
            toolbarStack.addArrangedSubview(editShopButton)
            toolbarStack.addSubview(locationButton)
            toolbarStack.addArrangedSubview(locationButton)
            toolbarStack.setNeedsUpdateConstraints()
            toolbarStack.setNeedsLayout()
            toolbarStack.setNeedsDisplay()
        }
    }
    
    override func viewDidLayoutSubviews() {
        let calculatedHeight = UIScreen.main.bounds.height * 1.2
        //print("Calculated Height : ",calculatedHeight)
        mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: calculatedHeight)
        
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        getShopFromServer()
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShopFromServer()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        changeToShopOwnerIfNeeded()
        self.shopUI = ShopUI(self)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard (self.shopUI != nil) && (self.shopUI.collectionView != nil) else {
            return
        }
        DispatchQueue.main.async{
            self.shopUI!.collectionView.reloadData()
        }
    }
    
}







