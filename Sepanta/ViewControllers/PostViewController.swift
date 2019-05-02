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
    
    @IBOutlet weak var editPostButton: UIButton!
    @IBOutlet weak var deletePostButton: UIButton!
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var postTitleLabelInHeader: UILabel!
    
    @IBAction func BackTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        postUI = nil
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    @IBAction func editTapped(_ sender: Any) {
        showQuestion(Message: "آيا می خواهید این پست را ویرایش کنید؟", OKLabel: "بلی", CancelLabel: "خیر", QuestionTag: 2)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        showQuestion(Message: "آيا از حذف پست مطمئن هستید؟", OKLabel: "بلی", CancelLabel: "خیر", QuestionTag: 1)
    }
    
    @objc override func okPressed(_ sender: Any) {
        if let okButton = sender as? UIButton {
            if okButton.tag == 1 {
                print("Delete Post")
                let aParameter = ["post_id":"\(self.postID ?? 0)"]
                NetworkManager.shared.run(API: "post-delete", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
                NetworkManager.shared.messageObs
                    .filter({$0.count > 0})
                    .subscribe(onNext: { [unowned self] amessage in
                        self.alert(Message: amessage)
                        NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
                        }).disposed(by: myDisposeBag)
            }else if okButton.tag == 2 {
                print("Edit Post")
            }
            okButton.superview?.removeFromSuperview()
        }
    }
    func editAuthorized()-> Bool{
        print("***Check Authorization : ","\(NetworkManager.shared.profileObs.value.id ?? 0)" ,"  ",LoginKey.shared.userID)
        if "\(NetworkManager.shared.profileObs.value.id ?? 0)" == LoginKey.shared.userID {
            return true
        }else{
            return false
        }
        
    }
    func initUI(){
        let authorized = editAuthorized()
        if !authorized {
            editPostButton.setImage(UIImage(named: "icon_edit_grey"), for: .disabled)
            deletePostButton.setImage(UIImage(named: "icon_delete_grey"), for: .disabled)
            editPostButton.isEnabled = false
            deletePostButton.isEnabled = false
        }else{
            editPostButton.setImage(UIImage(named: "icon_edit_grey"), for: .normal)
            deletePostButton.setImage(UIImage(named: "icon_delete_grey"), for: .normal)
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
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        getPostData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPostData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        initUI()
        self.postUI = PostUI(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkManager.shared.postDetailObs.accept(Post())
        self.postUI = nil
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
