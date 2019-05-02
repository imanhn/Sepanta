//
//  EditShopViewController.swift
//  Sepanta
//
//  Created by Iman on 2/12/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage


class EditShopViewController :  UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded,UIViewControllerWithImagePicker{
    var imagePicker = UIImagePickerController()
    
    var imagePickerDelegate: ImagePicker!
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopLogo: UIImageView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var shopLogoTrailing: NSLayoutConstraint!
    @IBOutlet weak var textFormView: UIView!
    
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    var shop : Shop!
    var editshopUI : EditShopUI!
    
    @IBAction func homeTapped(_ sender: Any) {
        editshopUI = nil
        //NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: Profile())
        self.coordinator!.popHome()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        editshopUI = nil
        //NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: Profile())
        self.coordinator!.popOneLevel()
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
    override func viewDidLayoutSubviews() {
        
        let calculatedHeight = UIScreen.main.bounds.height * 1.2
        //print("Calculated Height : ",calculatedHeight)
        mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: calculatedHeight)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getShopFromServer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        self.editshopUI = EditShopUI(self)
    }
    
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        //print("Showing POPUP : ",sourceView)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
