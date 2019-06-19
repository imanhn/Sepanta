//
//  PostViewController.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

class PostViewController :  UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded{
    var postUI : PostUI!
    var coordinator : HomeCoordinator!
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    var postID : Int?
    var postOwnerUserID : Int?
    var abuseButton = UIButton(type: .custom)
    @IBOutlet weak var editPostButton: UIButton!
    @IBOutlet weak var deletePostButton: UIButton!
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var postTitleLabelInHeader: UILabel!
    @IBOutlet weak var toolbarStack: UIStackView!

    @IBOutlet weak var toolbarWidthConsShort: NSLayoutConstraint!
    @IBOutlet weak var toolbarWidthConsWide: NSLayoutConstraint!
    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
        postUI = nil
    }

    @IBAction func BackTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    @IBAction func editTapped(_ sender: Any) {
        if
            let ashopID = NetworkManager.shared.postDetailObs.value.shop_id,
            let apost_id = NetworkManager.shared.postDetailObs.value.id,
            let apostTitle = NetworkManager.shared.postDetailObs.value.title,
            let apostBody = NetworkManager.shared.postDetailObs.value.content,
            let postUIImage = postUI.postImage.image {
            self.coordinator!.pushEditPost(shop_id: ashopID, post_id: apost_id, post_title: apostTitle, post_body: apostBody, post_image: postUIImage)
        }else{
            alert(Message: "اطلاعات پست برای ویرایش کامل نیست")
        }        
    }
    
    @objc func reportPost(_ sender : Any) {
        let offsetY = (self.view.frame.height) / 2
        let offsetX : CGFloat = 20
        let w = self.view.frame.width - (2 * offsetX)
        let h = w/2
        let aRepPostView = ReportPostView(frame: CGRect(x: offsetX, y: offsetY, width:w, height: h), PostID: postID!)
        self.view.addSubview(aRepPostView)
        NetworkManager.shared.serverMessageObs = BehaviorRelay<String>(value: "")
        NetworkManager.shared.serverMessageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] amessage in
                NetworkManager.shared.serverMessageObs = BehaviorRelay<String>(value: "")
                self.alert(Message: amessage)
            }).disposed(by: myDisposeBag)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        showDarkQuestion(Message: "آيا از حذف این پست مطمئن هستید؟", OKLabel: "بلی", CancelLabel: "خیر", OkAction: {self.deletePost(sender)})
    }
    
    func deletePost(_ sender : Any){
        print("Delete Post")
        let aParameter = ["post_id":"\(self.postID ?? 0)"]
        NetworkManager.shared.run(API: "post-delete", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        NetworkManager.shared.serverMessageObs = BehaviorRelay<String>(value: "")
        NetworkManager.shared.serverMessageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] amessage in
                NetworkManager.shared.serverMessageObs = BehaviorRelay<String>(value: "")
                //Updating my Posts!
                self.getMyShopFromServer()
                self.alert(Message: amessage)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.BackTapped(sender)
                })
            }).disposed(by: myDisposeBag)
    }
    
    func getMyShopFromServer() {
        NetworkManager.shared.shopProfileObs = BehaviorRelay<ShopProfile>(value: ShopProfile())
        //print("self.shop.user_id : ",self.shop.user_id)
        let aParameter = ["user id":LoginKey.shared.userID]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true,TargetObs: "SHOP")
    }

    func editAuthorized()-> Bool{
        if "\(postOwnerUserID ?? 0)" == LoginKey.shared.userID
        {
            print("PostOwner is Logged!")
            return true
        }else{
            print("postownerUserID : \(postOwnerUserID ?? 0)","  Login userID",LoginKey.shared.userID)
        }
        print("***Check Post Authorization : ","\(NetworkManager.shared.shopProfileObs.value.id ?? 0)" ,"  ",LoginKey.shared.userID)
        if "\(NetworkManager.shared.profileObs.value.id ?? 0)" == LoginKey.shared.userID {
            return true
        }else{
            return false
        }
    }
    
    func initUI(){
        let authorized = editAuthorized()
        if !authorized {
            print("*** NOT Authorized")
            deletePostButton.isHidden = true
            editPostButton.isHidden = true
            
            abuseButton = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            abuseButton.setImage(UIImage(named: "abuseButton"), for: .normal)
            abuseButton.addTarget(self, action: #selector(reportPost(_:)), for: .touchUpInside)
            toolbarWidthConsWide.isActive = false
            toolbarWidthConsShort.isActive = true
            toolbarStack.addSubview(abuseButton)
            toolbarStack.addArrangedSubview(abuseButton)
            toolbarStack.setNeedsUpdateConstraints()
            toolbarStack.setNeedsLayout()
            toolbarStack.setNeedsDisplay()
        }else{
            print("*** Authorized")
            editPostButton.setImage(UIImage(named: "icon_edit"), for: .normal)
            deletePostButton.setImage(UIImage(named: "icon_delete"), for: .normal)
            toolbarWidthConsWide.isActive = true
            toolbarWidthConsShort.isActive = false
            editPostButton.isEnabled = true
            deletePostButton.isEnabled = true
        }
    }
    
    func getPostData(){
        if postID == nil {
            print("Unable to get data")
            self.alert(Message: "اطلاعات این پست ناقص است")
            return
        }
        Spinner.start()
        let aParameter = ["post_id":"\(postID!)"]
        NetworkManager.shared.run(API: "post-details", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] amessage in
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
                self.alert(Message: amessage)
            })
        messageDisp.disposed(by: myDisposeBag)
        disposeList.append(messageDisp)
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        getPostData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("WILL APEAR : POST ID : ",postID)
        super.viewWillAppear(animated)
        //getPostData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPostData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        initUI()
        self.postUI = PostUI(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NetworkManager.shared.postDetailObs.accept(Post())
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
