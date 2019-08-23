//
//  ImagePicker.swift
//  Sepanta
//
//  Created by Iman on 2/12/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift
/*
protocol UIViewControllerWithImagePicker : class {
    var imagePicker : UIImagePickerController {get set}
    var imagePickerDelegate : ImagePicker! {get set}
}*/
protocol UIViewControllerWithImagePicker: class {
    var imagePicker: UIImagePickerController! {get set}
    var imagePickerDelegate: ImagePicker! {get set}
}
class ImagePicker: NSObject,
    RSKImageCropViewControllerDelegate,
    RSKImageCropViewControllerDataSource,
    UINavigationControllerDelegate,
UIImagePickerControllerDelegate {

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        fatalError()
    }

    var owner: UIViewControllerWithImagePicker & UIViewController

    init(_ vc: UIViewControllerWithImagePicker & UIViewController) {
        self.owner = vc
        super.init()
        launchImagePicker()
    }
    func launchImagePicker() {
        let alert = UIAlertController(title: "نحوه انتخاب عکس", message: nil, preferredStyle: .actionSheet)
        let camAction = UIAlertAction(title: "دوربین", style: .default, handler: { _ in
            self.openCamera()
        })
        alert.addAction(camAction)

        alert.addAction(UIAlertAction(title: "گالری", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "لغو", style: .cancel, handler: nil))
        owner.present(alert, animated: true, completion: nil)
    }

    func openCamera() {
        owner.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        owner.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        owner.present(owner.imagePicker, animated: true, completion: nil)
    }
    func openGallary() {
        owner.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        owner.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        owner.present(owner.imagePicker, animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String: Any]) {

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        self.pushCropper(image)
        picker.dismiss(animated: true, completion: nil)
    }

    func pushCropper(_ selectedImage: UIImage) {
        let imageCropViewController = RSKImageCropViewController(image: selectedImage, cropMode: .circle)
        imageCropViewController.delegate = self
        imageCropViewController.dataSource = self
        owner.navigationController?.pushViewController(imageCropViewController, animated: true)
    }
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.owner.navigationController?.popViewController(animated: true)
    }

    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return .zero
    }

    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath(rect: controller.maskRect)
    }

    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return .zero//CGRect(x: 0, y: 0, width: 100 , height: 100)
    }
}
