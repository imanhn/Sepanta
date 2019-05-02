//
//  AddPostViewController.swift
//  Sepanta
//
//  Created by Iman on 2/12/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import AlamofireImage
import Photos

class AddPostViewController : UIViewControllerWithKeyboardNotificationWithErrorBar,XIBView,UITableViewDelegate,UIViewControllerWithImagePicker{
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    weak var coordinator : HomeCoordinator?
    var imagePicker = UIImagePickerController()
    var imagePickerDelegate : ImagePicker!

    @IBOutlet weak var postImageButton: RoundedButtonWithShadow!
    @IBOutlet weak var titleTextField: UnderLinedTextField!
    @IBOutlet weak var bodyTextField: UnderLinedTextField!
    @IBOutlet weak var submitButton: SubmitButton!
    @IBOutlet weak var mainView: UIView!

    @IBAction func submitTapped(_ sender: Any) {
        self.view.endEditing(true)
        let atitle = (self.titleTextField.text!).data(using: .utf8)!
        let abody = (self.bodyTextField.text!).data(using: .utf8)!
        let postImage = self.postImageButton.image(for: .normal)
        let imageData = UIImageJPEGRepresentation(postImage!, 0.2)!
        let targetUrl = URL(string: NetworkManager.shared.baseURLString+"/new-post")!
        Spinner.start()
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
            multipartFormData.append(atitle, withName: "title")
            multipartFormData.append(abody, withName: "body")
        }, usingThreshold: UInt64.init(), to: targetUrl, method: HTTPMethod.post, headers: NetworkManager.shared.headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _ , _):
                print("SUCCEED,Sending Post Image....")
                self.submitButton.setDisable()
                upload.responseJSON { response in
                    
//                    print("RESPONDED : ",response)
//                    print("response.result : ",response.result)
//                    print("response.value : ",response.value)
                    if let aDic = response.value as? NSDictionary {
                        if let aStatus = aDic["status"] as? String,
                            let aMessage = aDic["message"] as? String{
                            print("** CASTED! Succeess ** ","aStatus : ",aStatus)
                            self.alert(Message: aMessage)
                        }
                    }
                    self.submitButton.setEnable()
                    if response.value != nil {
                        print("** Succeess ** ")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.coordinator!.popOneLevel()
                            Spinner.stop()
                        })
                    }
                    //debugPrint(response)
                }
            case .failure(let encodingError):
                print("Uploading image Failed : ",encodingError)
                Spinner.stop()
                self.alert(Message: "عملیات با مشکل مواجه شد مجددا تلاش بفرمایید")
                self.submitButton.setEnable()
            }
        })
    }
    
    
    @IBAction func postImageTapped(_ sender: Any) {
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
                    self.imagePickerDelegate = AddPostImagePicker(self)
                    break
                }
            })
        }else{
            imagePickerDelegate = AddPostImagePicker(self)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popHome()
    }
    
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
    }
    
    func handleSubmitButtonEnableOrDisable(){
        Observable.combineLatest([titleTextField.rx.text,
                                  bodyTextField.rx.text
            ])
            .subscribe(onNext: { (combinedTexts) in
                //print("combinedTexts : ",combinedTexts)
                let mappedTextToBool = combinedTexts.map{$0 != nil && $0!.count > 0}
                //print("mapped : ",mappedTextToBool)
                let allTextFilled = mappedTextToBool.reduce(true, {$0 && $1})
                if allTextFilled {
                    if !self.submitButton.isEnabled {
                        self.submitButton.setEnable()
                    }
                }else{
                    if self.submitButton.isEnabled {
                        self.submitButton.setDisable()
                    }
                }
            }
            ).disposed(by: self.myDisposeBag)
    }
    
    func initUI(){
        let gradient = CAGradientLayer()
        gradient.frame = self.mainView.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        mainView.layer.insertSublayer(gradient, at: 0)
        submitButton.setDisable()
        handleSubmitButtonEnableOrDisable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)

    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}
