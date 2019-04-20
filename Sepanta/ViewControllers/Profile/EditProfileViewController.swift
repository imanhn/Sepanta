//
//  EditProfileViewController.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift
import Photos

class EditProfileViewController : UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded{

    @IBOutlet weak var formView: UIView!
    @IBOutlet var topView: UIView!
    weak var coordinator : HomeCoordinator?
    var editProfileUI : EditProfileUI!
    var myDisposeBag = DisposeBag()
    var imagePicker = UIImagePickerController()
    var imagePickerDelegate : EditProfileImagePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func selectProfileImage(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                switch status {
                case PHAuthorizationStatus.denied :
                    //self.alert(Message: "دسترسی به تصاویر داده نشد")
                    break
                case PHAuthorizationStatus.restricted :
                    //self.alert(Message: "دسترسی به تصاویر لازم است")
                    break
                case .notDetermined:
                    //self.alert(Message: "دسترسی به تصاویر لازم است")
                    break
                case .authorized:
                    self.imagePickerDelegate = EditProfileImagePicker(self)
                    break
                }
            })
        }else{
            imagePickerDelegate = EditProfileImagePicker(self)
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        editProfileUI = nil
        imagePickerDelegate = nil
        self.coordinator?.popOneLevel()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        editProfileUI.sendEditedData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        editProfileUI = EditProfileUI(self)        
    }
    
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
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
