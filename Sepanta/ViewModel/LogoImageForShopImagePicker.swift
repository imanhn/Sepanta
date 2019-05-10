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
        uploadPicture()
    }
    
    func uploadPicture(){
        Spinner.start()
        let profileimage = self.editShopViewController.shopLogo.image!
        let imageData = UIImageJPEGRepresentation(profileimage, 0.2)!
        let targetUrl = URL(string: NetworkManager.shared.baseURLString+"/profile-image")!
        var messageAlerted = false
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
        }, usingThreshold: UInt64.init(), to: targetUrl, method: HTTPMethod.post, headers: NetworkManager.shared.headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _ , _):
                print("SUCCEED,Sending Logo Image....")
                upload.responseJSON { response in
                    if let aDic = response.value as? NSDictionary {
                        if let aStatus = aDic["status"] as? String,
                            let aMessage = aDic["message"] as? String{
                            print("** CASTED! Succeess ** ","aStatus : ",aStatus)
                            messageAlerted = true
                            self.editShopViewController.alert(Message: aMessage)
                        }
                    }
                    if response.value != nil {
                        if messageAlerted == false { self.editShopViewController.alert(Message: "تصویر بارگذاری شد") }
                        print("** Succeess ** ")
                    }
                    //debugPrint(response)
                }
                Spinner.stop()
            case .failure(let encodingError):
                if messageAlerted == false { self.editShopViewController.alert(Message: "عملیات بارگذاری تصویر با خطا مواجه شد، لطفاْ مجددا تلاش بفرمایید") }
                print("Uploading image Failed : ",encodingError)
                Spinner.stop()
            }
        })
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
