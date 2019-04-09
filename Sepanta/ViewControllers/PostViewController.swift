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

class PostViewController :  UIViewControllerWithErrorBar,Storyboarded{
    var postUI : PostUI!
    var coordinator : HomeCoordinator!
    //var post = BehaviorRelay<Post>(value: Post())
    var postID : Int?
    @IBOutlet weak var postScrollView: UIScrollView!
    
    @IBAction func BackTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    @IBOutlet weak var BackTapped: UIButton!
    
    func getPostData(){
        //"http://www.panel.ipsepanta.ir/api/v1/post-details?post_id=35"
        if postID == nil {
            print("Unable to get data")
            self.alert(Message: "اطلاعات این پست ناقص است")
            return
        }
        let aParameter = ["post_id":"\(postID!)"]
        NetworkManager.shared.run(API: "post-details", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil)
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        getPostData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPostData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postUI = PostUI(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NetworkManager.shared.postDetailObs.accept(Post())
        self.postUI = nil
    }
}
