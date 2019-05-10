//
//  HomeViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HomeViewController: UIViewControllerWithErrorBar,Storyboarded {
    weak var coordinator : HomeCoordinator?
    var myDisposeBag = DisposeBag()
    var slideControl : SlideController?
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var searchText: CustomSearchBar!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var currentImageView: AdImageView!
    @IBOutlet weak var leftImageView: AdImageView!
    @IBOutlet weak var rightImageView: AdImageView!
    @IBOutlet weak var newShopsButton: UIButtonWithBadge!
    @IBOutlet weak var notificationsButton: UIButtonWithBadge!
    @IBOutlet weak var slideView: UIView!
    
    @IBAction func gotoFavorites(_ sender: Any) {
        self.coordinator!.pushFavoriteList()
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let akeyword = self.searchText.text ?? ""       
        self.coordinator!.PushSearch(Keyword: akeyword)
    }
    
    @IBAction func gotoNotifications(_ sender: Any) {
        self.coordinator!.pushNotifications()
    }
    
    @IBAction func gotoHelp(_ sender: Any) {
        alert(Message: "نمایش کمک")
    }
    
    @IBAction func gotoMapNearestShop(_ sender: Any) {
        self.coordinator!.pushNearest()
    }
    
    @IBOutlet weak var searchTextField: CustomSearchBar!
    
    @IBAction func gotoProfile(_ sender: Any) {
        self.coordinator!.pushShowProfile()
        //self.coordinator!.logout()
    }
    @IBAction func gotoNewShops(_ sender: Any) {
        self.coordinator!.pushNewShops()
    }
    @IBAction func menuClicked(_ sender: Any) {
        guard self.coordinator != nil else {
            print("HomeVC : self.coordinator is nil!")
            return
        }
        self.coordinator!.openButtomMenu()
    }

    @IBAction func searchOnKeyboardPressed(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
        
    }

    //Passes events to delegate class

    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        SlidesAndPaths.shared.getHomeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideControl = SlideController(parentController: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("Stoping Slider")
        slideControl?.endTimer()
    }
    func subscribeForBadges(){
        SlidesAndPaths.shared.count_new_shop
            .subscribe(onNext: { [unowned self] newShopNo in
                self.newShopsButton.manageBadge(newShopNo)
                }
        ).disposed(by: myDisposeBag)

        SlidesAndPaths.shared.notifications_count
            .subscribe(onNext: { [unowned self] notiCount in                
                self.notificationsButton.manageBadge(notiCount)
                }
            ).disposed(by: myDisposeBag)
    }
    
    @objc func doAnimateLogo(){
        self.logo.animateView()
    }
    
    func animateLogo(){
        let animateLogo = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(doAnimateLogo), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        subscribeForBadges()
        animateLogo()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        
    }
    
    @objc func viewTapped(_ sender:UITapGestureRecognizer){
        slideControl?.handleTap(sender)
    }
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        if slideControl != nil {
            slideControl?.handlePan(sender)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sepantaieClicked(_ sender: Any) {
        self.coordinator!.pushSepantaieGroup()
    }
    
    @IBAction func poldarshoClicked(_ sender: Any) {
        //print("HomeViewController.Coordinator : ",coordinator)
        self.coordinator!.pushGetRich(nil)
        
    }
    
}


