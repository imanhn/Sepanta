//
//  MainImageForShopImagePicker.swift
//  Sepanta
//
//  Created by Iman on 2/13/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
//
//  AddPostImagePicker.swift
//  Sepanta
//
//  Created by Iman on 2/12/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift


class MainImageForShopImagePicker : ImagePicker {
    var editShopViewController : EditShopViewController
    
    init(_ vc : EditShopViewController){
        self.editShopViewController = vc
        super.init(vc)
    }
    
    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.editShopViewController.navigationController?.popViewController(animated: true)
        self.editShopViewController.shopImage.image = croppedImage
        uploadPicture()
    }
    
    func uploadPicture(){
        let profileimage = self.editShopViewController.shopImage.image!
        let imageData = UIImageJPEGRepresentation(profileimage, 0.2)!
        let targetUrl = URL(string: NetworkManager.shared.baseURLString+"/profile-image")!
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
        }, usingThreshold: UInt64.init(), to: targetUrl, method: HTTPMethod.post, headers: NetworkManager.shared.headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _ , _):
                print("SUCCEED,Updating Profile....")
                let aParameter = ["user id":"\(LoginKey.shared.userID)"]
                NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
                upload.responseJSON { response in
                    //print("RESPONDED : ",response)
                    //debugPrint(response)
                }
            case .failure(let encodingError):
                print("Uploading image Failed : ",encodingError)
            }
        })
    }
    override func pushCropper(_ selectedImage : UIImage){
        let imageCropViewController = RSKImageCropViewController(image: selectedImage, cropMode: .custom)
        imageCropViewController.delegate = self
        imageCropViewController.dataSource = self
        owner.navigationController?.pushViewController(imageCropViewController, animated: true)
    }
    override func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        let ratio : CGFloat = 2
        let offsetY = (UIScreen.main.bounds.height - (UIScreen.main.bounds.width/ratio))/2
        let maskHeight = UIScreen.main.bounds.width/ratio
        let recmask = CGRect(x: 0 , y: offsetY, width: UIScreen.main.bounds.width , height: maskHeight)
        return recmask
    }
    
    override func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath(rect: controller.maskRect)
    }
    
    override func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        let ratio : CGFloat = 2
        let offsetY = (UIScreen.main.bounds.height - (UIScreen.main.bounds.width/ratio))/2
        let maskHeight = UIScreen.main.bounds.width/ratio
        let recmask = CGRect(x: 0 , y: offsetY, width: UIScreen.main.bounds.width , height: maskHeight)
        return recmask
    }
}
