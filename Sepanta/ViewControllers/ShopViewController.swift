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
    @IBOutlet weak var paneView: UIView!
    @IBOutlet weak var PostToolbarView: UIView!
    
    @IBOutlet weak var offLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var shopLogoTrailing: NSLayoutConstraint!
    @IBOutlet weak var shopLogoShopTitleDistance: NSLayoutConstraint!
    
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
        self.coordinator!.pushShopMap(self.shop)
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
    
    @objc func showPostTapped(_ sender : Any) {
        shopUI!.showShopPosts()
    }
    
    @objc func contactTapped(_ sender : Any) {
        //Refactor needed
        //When I go to a post and come back ShopUI will be released and here is the place I get an exception!
        shopUI!.showContacts()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        getShopFromServer()
    }
    
    func getShopFromServer() {
        guard self.shop.user_id != 0 && self.shop.user_id != nil else {
            alert(Message: "اظلاعات این فروشگاه کامل نیست")
            return
        }
        let aParameter = ["user id":"\(self.shop.user_id!)"]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getShopFromServer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        
        self.shopUI = ShopUI(self)
    }
    

    
}







