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
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
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
    @IBAction func showPostsTapped(_ sender: Any) {
        self.panelView.tabJust = .Right
        self.panelView.setNeedsDisplay()
        self.shopUI!.showShopPosts()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        shopUI = nil
        self.coordinator!.logout()
    }
    
    @IBAction func showContactTapped(_ sender: Any) {
        self.panelView.tabJust = .Left
        self.panelView.setNeedsDisplay()
        self.shopUI!.showContacts()
    }
    @IBAction func homeTapped(_ sender: Any) {
        shopUI = nil
        NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: Profile())
        NetworkManager.shared.shopFav = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
        //shopDataSource = nil
        self.coordinator!.popHome()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        shopUI = nil
        NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: Profile())
        NetworkManager.shared.shopFav = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
        //shopDataSource = nil
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
        // Toggle Favorite the shop
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
        //print("self.shop.user_id : ",self.shop.user_id)
        guard self.shop.user_id != 0 && self.shop.user_id != nil else {
            alert(Message: "اظلاعات این فروشگاه کامل نیست")
            return
        }
        let aParameter = ["user id":"\(self.shop.user_id!)"]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
    }
    
    func editAuthorized()-> Bool{
        print("***Check Authorization : ","\(self.shop.user_id ?? 0)" ,"  ",LoginKey.shared.userID)
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
        let calculatedHeight = UIScreen.main.bounds.height * 1.5
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
    

    
}







