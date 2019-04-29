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
    
    @IBOutlet weak var BackTapped: UIButton!
    
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
