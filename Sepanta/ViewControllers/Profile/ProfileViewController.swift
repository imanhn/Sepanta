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
import RxCocoa

class ProfileViewController: UIViewControllerWithErrorBar, Storyboarded {
    weak var coordinator: HomeCoordinator?
    var showUserProfileUI: ShowUserProfileUI!
    var myDisposeBag = DisposeBag()
    var userPointsObs = BehaviorRelay<UserPoints>(value: UserPoints())
    @IBOutlet weak var cupLabel: UILabel!
    @IBOutlet weak var cupScoreLabel: UILabel!
    @IBOutlet weak var clubNumLabel: UILabel!
    @IBOutlet weak var paneView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var reagentCodeLabel: UILabel!
    
    @IBAction func showScoreTapped(_ sender: Any) {
        self.coordinator!.pushScores(userPointsObs.value)
    }

    @IBAction func favTapped(_ sender: Any) {
        self.coordinator!.pushFavoriteList()
    }

    @IBAction func menuTapped(_ sender: Any) {
        print("Menu Tapped")
        self.coordinator!.openButtomMenu()
    }

    @IBAction func editTapped(_ sender: Any) {
        self.coordinator!.pushEditProfile()
    }
    /*
    @IBAction func logoutTapped(_ sender: Any) {
        showProfileUI = nil
        self.coordinator!.logout()
    }*/

    @objc override func willPop() {
        showUserProfileUI.disposeList.forEach({$0.dispose()})
        showUserProfileUI = nil
    }

    @IBAction func backPressed(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }

    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }

    @objc func myClubTapped(_ sender: Any) {
        showUserProfileUI!.showMyClub()
    }

    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
        if LoginKey.shared.role == "User" {
            showUserProfileUI = ShowUserProfileUI(self)
        } else {
            //showShopProfileUI = ShowShopProfileUI(self)
        }

    }

    override func viewDidLayoutSubviews() {
        let viewWidth = self.view.frame.width
        let calculatedHeight = viewWidth * ( 0.25 + 0.125 + 0.5 + 1.25 + 0.125 + 0.125)
        //print("Calculated Height : ",calculatedHeight)
        profileScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: calculatedHeight)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        showUserProfileUI = ShowUserProfileUI(self)
    }
    
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        //print("Showing POPUP : ",sourceView)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
}
