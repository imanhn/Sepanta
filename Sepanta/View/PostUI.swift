//
//  PostUI.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PostUI {
    var delegate : PostViewController
    var scrollBar : UIScrollView!
    var myDisposeBag = DisposeBag()
    init (_ vc : PostViewController){
        self.delegate = vc
        self.buildPostView()
    }
    
    func buildPostView(){
        NetworkManager.shared.postDetailObs
            .subscribe(onNext: { [unowned self] (innerPost) in
                let aFont = UIFont(name: "Shabnam-FD", size: 16)
                var cursurY : CGFloat = 0
                let marginY : CGFloat = (UIScreen.main.bounds.width / 6)  //10
                let gradient = CAGradientLayer()
                gradient.frame = self.delegate.view.bounds
                gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
                self.delegate.postScrollView.layer.insertSublayer(gradient, at: 0)
                self.delegate.postScrollView.semanticContentAttribute = .forceRightToLeft
                let postImage = UIImageView(frame: CGRect(x: 15, y: 20, width: self.delegate.postScrollView.frame.width-2*15, height: self.delegate.postScrollView.frame.width-2*15))
                if innerPost.image != nil {
                    let imageStrUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + innerPost.image!
                    print("PostUI : Reading : ",imageStrUrl)
                    let imageCastedURL = URL(string: imageStrUrl)
                    if imageCastedURL != nil {
                        postImage.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageCastedURL!, ImageName: innerPost.image!)
                    }else{
                        print("PostUI : Post Image can not be casted.")
                    }
                    self.delegate.postScrollView.addSubview(postImage)
                }
            }).disposed(by: myDisposeBag)
    }
}
