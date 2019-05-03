//
//  LogoImageForShopImagePicker.swift
//  Sepanta
//
//  Created by Iman on 2/13/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//


import Foundation
import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift


class LogoImageForShopImagePicker : ImagePicker {
    var editShopViewController : EditShopViewController
    
    init(_ vc : EditShopViewController){
        self.editShopViewController = vc
        super.init(vc)
    }
    
    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.editShopViewController.navigationController?.popViewController(animated: true)
        self.editShopViewController.shopLogo.image = croppedImage
    }
    
    override func pushCropper(_ selectedImage : UIImage){
        let imageCropViewController = RSKImageCropViewController(image: selectedImage, cropMode: .square)
        imageCropViewController.delegate = self
        imageCropViewController.dataSource = self
        owner.navigationController?.pushViewController(imageCropViewController, animated: true)
    }
    override func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return .zero
    }
    
    override func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath(rect: controller.maskRect)
    }
    
    override func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return .zero
    }
}
