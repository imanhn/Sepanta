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


class ShopViewController :  UIViewController,Storyboarded{
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    var profileRelay = BehaviorRelay<Profile>(value: Profile())
    var shop : Shop!
    var shopUI : ShopUI!
    var shopDataSource : ShopDataSource!
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
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBAction func followTapped(_ sender: Any) {
    }
    
    @IBAction func shareTapped(_ sender: Any) {
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func locationTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
    }
    
    @objc func showPostTapped(_ sender : Any) {
        shopUI!.showShopPosts()
    }
    
    @objc func contactTapped(_ sender : Any) {
        shopUI!.showContacts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopDataSource = ShopDataSource(self)
        self.shopUI = ShopUI(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shopUI = nil
        shopDataSource = nil
    }
    
}







