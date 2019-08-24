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

class EditProfileViewController: UIViewControllerWithKeyboardNotificationWithErrorBar, Storyboarded, UIViewControllerWithImagePicker {

    @IBOutlet weak var formView: UIView!
    @IBOutlet var topView: UIView!
    weak var coordinator: HomeCoordinator?
    var editProfileUI: EditProfileUI!
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    var imagePickerDelegate: ImagePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePicture: UIImageView!

    @IBAction func selectProfileImage(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                switch status {
                case PHAuthorizationStatus.denied :
                    self.alert(Message: "دسترسی به تصاویر داده نشد")                    
                case PHAuthorizationStatus.restricted :
                    self.alert(Message: "دسترسی به تصاویر لازم است")
                case .notDetermined:
                    self.alert(Message: "دسترسی به تصاویر لازم است")
                case .authorized:
                    self.imagePickerDelegate = EditProfileImagePicker(self)
                }
            })
        } else {
            imagePickerDelegate = EditProfileImagePicker(self)
        }
    }
    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
        editProfileUI?.disposeList.forEach({$0.dispose()})
        editProfileUI = nil
        imagePickerDelegate = nil
    }

    @IBAction func backTapped(_ sender: Any) {
        self.coordinator?.popOneLevel()
    }

    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator?.popHome()
    }

    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
        editProfileUI.sendEditedData(sender as! UIButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        editProfileUI = EditProfileUI(self)
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
