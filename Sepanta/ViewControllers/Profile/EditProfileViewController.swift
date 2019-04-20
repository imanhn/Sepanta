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


class EditProfileViewController : UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.profilePicture.image = croppedImage
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return CGRect(x: 0, y: 0, width: 375, height: 200)
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath(rect: controller.maskRect)
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return CGRect(x: 0, y: 0, width: 100 , height: 100)
    }
    

    
    @IBOutlet weak var formView: UIView!
    @IBOutlet var topView: UIView!
    weak var coordinator : HomeCoordinator?
    var editProfileUI : EditProfileUI! = EditProfileUI()
    var myDisposeBag = DisposeBag()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func selectProfileImage(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        self.present(imagePicker, animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        var image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        picker.dismiss(animated: false, completion: { () -> Void in
            
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.Circle)
            
            imageCropVC.delegate = self
            
            self.navigationController?.pushViewController(imageCropVC, animated: true)
            
        })
        
    }
 */
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        pushCropper(image)
        /*
        self.profilePicture.image = image
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
        self.profilePicture.layer.masksToBounds = true
        self.profilePicture.layer.borderColor = UIColor.white.cgColor
        self.profilePicture.layer.borderWidth = 4
         */
    }

    @IBAction func backTapped(_ sender: Any) {
        editProfileUI = nil
        self.coordinator?.popOneLevel()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        editProfileUI.sendEditedData()
    }
    
    func pushCropper(_ selectedImage : UIImage){
        let imageCropViewController = RSKImageCropViewController(image: selectedImage, cropMode: .custom)
        imageCropViewController.delegate = self
        imageCropViewController.dataSource = self
        self.navigationController?.pushViewController(imageCropViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        editProfileUI.showForm(self)
        //setupImagePicker()
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
