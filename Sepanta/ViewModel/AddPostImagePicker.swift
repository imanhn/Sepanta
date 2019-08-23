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

class AddPostImagePicker: ImagePicker {
    var addPostViewController: AddPostViewController

    init(_ vc: AddPostViewController) {
        self.addPostViewController = vc
        super.init(vc)
    }

    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.addPostViewController.navigationController?.popViewController(animated: true)
        self.addPostViewController.postImageButton.setImage(croppedImage, for: .normal)
    }

    override func pushCropper(_ selectedImage: UIImage) {
        let imageCropViewController = RSKImageCropViewController(image: selectedImage, cropMode: .square)
        imageCropViewController.delegate = self
        imageCropViewController.dataSource = self
        owner.navigationController?.pushViewController(imageCropViewController, animated: true)
    }

}
