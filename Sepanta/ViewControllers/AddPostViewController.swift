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
    var imagePicker : UIImagePickerController! = UIImagePickerController()
    var imagePickerDelegate : ImagePicker!

    var shop_id : Int?
    var post_id : Int?
    var postTitle : String?
    var postBody : String?
    var postUIImage : UIImage?
    var editMode : Bool = false

    @IBOutlet weak var postImageButton: RoundedButtonWithShadow!
    @IBOutlet weak var titleTextField: UnderLinedTextField!
    @IBOutlet weak var bodyTextField: UnderLinedTextField!
    @IBOutlet weak var submitButton: SubmitButton!
    @IBOutlet weak var mainView: UIView!

    @IBAction func backTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        imagePickerDelegate = nil
        imagePicker = nil
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        imagePickerDelegate = nil
        imagePicker = nil
        self.coordinator!.popHome()
    }
    
    func loadCurrentData(){
        if let anImage = postUIImage{
            postImageButton.setImage(anImage, for: .normal)
        }
        if postTitle != nil { titleTextField.text = postTitle}
        if postBody != nil { bodyTextField.text = postBody}
        if post_id != nil && shop_id != nil {
            submitButton.setTitle("ویرایش", for: .normal)
            self.submitButton.setEnable()
            editMode = true
        }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if editMode {
            editPost(sender)
        }else{
            addNewPost(sender)
        }
    }
    
    func editPost(_ sender: Any) {
        self.view.endEditing(true)
        let apost_id = ("\(post_id!)").data(using: .utf8)!
        let ashop_id = ("\(shop_id!)").data(using: .utf8)!
        let atitle = (self.titleTextField.text!).data(using: .utf8)!
        let abody = (self.bodyTextField.text!).data(using: .utf8)!
        let postImage = self.postImageButton.image(for: .normal)
        let imageData = UIImageJPEGRepresentation(postImage!, 0.2)!
        let targetUrl = URL(string: NetworkManager.shared.baseURLString+"/edit-post")!
        Spinner.start()
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
            multipartFormData.append(atitle, withName: "title")
            multipartFormData.append(abody, withName: "body")
            multipartFormData.append(ashop_id, withName: "shop_id")
            multipartFormData.append(apost_id, withName: "post_id")
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
                        let aParameter = ["post_id":"\(self.post_id)"]
                        NetworkManager.shared.run(API: "post-details", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.backTapped(sender)
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
    
    func addNewPost(_ sender: Any) {
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
                    self.getMyShopFromServer()
                    if response.value != nil {
                        print("** Succeess ** ")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.backTapped(sender)
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
    

    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
    }
    
    func handleSubmitButtonEnableOrDisable(){
        let submitDisp = Observable.combineLatest([titleTextField.rx.text,
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
            )
        submitDisp.disposed(by: self.myDisposeBag)
        disposeList.append(submitDisp)
    }
    
    func getMyShopFromServer() {
        NetworkManager.shared.shopProfileObs = BehaviorRelay<Profile>(value: Profile())
        //print("self.shop.user_id : ",self.shop.user_id)
        let aParameter = ["user id":LoginKey.shared.userID]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true,TargetObs: "SHOP")
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
        loadCurrentData()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)

    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}
