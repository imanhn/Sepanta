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

class ProfileViewController : UIViewController,Storyboarded {
    weak var coordinator : HomeCoordinator?
    var showProfileUI : ShowProfileUI! = ShowProfileUI()
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
        self.coordinator!.popHome()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientTopView()
        showProfileUI!.showMyClub(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showProfileUI = nil
    }
}