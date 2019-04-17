//
//  ProfileViewController.swift
//  Sepanta
//
//  Created by Iman on 12/17/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift

class ProfileViewController : UIViewControllerWithErrorBar,Storyboarded {
    weak var coordinator : HomeCoordinator?
    var showProfileUI : ShowProfileUI! = ShowProfileUI()
    var myDisposeBag = DisposeBag()
    @IBOutlet var topView: UIView!
    @IBOutlet weak var cupLabel: UILabel!
    @IBOutlet weak var clubNumLabel: UILabel!
    @IBOutlet weak var paneView: UIView!
    
    @IBAction func menuTapped(_ sender: Any) {
        self.coordinator!.openButtomMenu()
    }
    @IBAction func editTapped(_ sender: Any) {
        self.coordinator!.pushEditProfile()
    }
    @IBAction func logoutTapped(_ sender: Any) {
        self.coordinator!.logout()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @objc func myClubTapped(_ sender : Any) {
        showProfileUI!.showMyClub(self)
    }
    
    @objc func contactTapped(_ sender : Any) {
        showProfileUI!.showContacts(self)
    }
    
    func gradientTopView(){
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        topView.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        showProfileUI!.showMyClub(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        gradientTopView()
        showProfileUI!.showMyClub(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showProfileUI = nil
    }
}
