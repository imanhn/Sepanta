//
//  EditProfileImagePicker.swift
//  Sepanta
//
//  Created by Iman on 1/31/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift

class EditProfileImagePicker: ImagePicker {
    var editProfileViewController: EditProfileViewController

    init(_ vc: EditProfileViewController) {
        self.editProfileViewController = vc
        super.init(vc)
    }

    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.editProfileViewController.navigationController?.popViewController(animated: true)
        self.editProfileViewController.profilePicture.image = croppedImage
        self.editProfileViewController.profilePicture.layer.cornerRadius = self.editProfileViewController.profilePicture.frame.width/2
        self.editProfileViewController.profilePicture.layer.masksToBounds = true
        self.editProfileViewController.profilePicture.layer.borderColor = UIColor.white.cgColor
        self.editProfileViewController.profilePicture.layer.borderWidth = 4
        uploadPicture()
    }

    func uploadPicture() {
        let profileimage = self.editProfileViewController.profilePicture.image!
        let imageData = UIImageJPEGRepresentation(profileimage, 0.2)!
        let targetUrl = URL(string: NetworkManager.shared.baseURLString+"/profile-image")!
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        }, usingThreshold: UInt64.init(), to: targetUrl, method: HTTPMethod.post, headers: NetworkManager.shared.headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                print("SUCCEED,Updating Profile....")
                let aParameter = ["user id": "\(LoginKey.shared.userID)"]
                NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
                upload.responseJSON { _ in
                    //print("RESPONDED : ",response)
                    //debugPrint(response)
                }
            case .failure(let encodingError):
                print("Uploading image Failed : ", encodingError)
            }
        })
    }
}
