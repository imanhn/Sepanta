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
    var showProfileUI : ShowProfileUI!
    var myDisposeBag = DisposeBag()
    @IBOutlet weak var cupLabel : UILabel!
    @IBOutlet weak var cupScoreLabel: UILabel!
    @IBOutlet weak var clubNumLabel : UILabel!
    @IBOutlet weak var paneView : UIView!
    @IBOutlet weak var profilePicture : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBAction func showScoreTapped(_ sender: Any) {
        self.coordinator!.pushScores()
    }
    
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
        showProfileUI = nil
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        showProfileUI = nil
        self.coordinator!.popHome()
    }
    
    @objc func myClubTapped(_ sender : Any) {
        showProfileUI!.showMyClub()
    }
    
    @objc func contactTapped(_ sender : Any) {
        showProfileUI!.showContacts()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        showProfileUI = ShowProfileUI(self)
        
    }
    
    override func viewDidLayoutSubviews() {
        let viewWidth = self.view.frame.width
        let calculatedHeight = viewWidth * ( 0.25 + 0.125 + 0.5 + 0.75 + 0.125 + 0.125)
        //print("Calculated Height : ",calculatedHeight)
        profileScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: calculatedHeight)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        showProfileUI = ShowProfileUI(self)
    }

}
