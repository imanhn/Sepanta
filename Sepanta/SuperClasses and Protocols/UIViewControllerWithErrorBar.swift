//
//  UIViewControllerWithErrorBar.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol ReloadableViewController {
    func ReloadViewController(_ sender:Any)
}

class UIViewControllerWithErrorBar : UIViewController,ReloadableViewController {
    
    @objc func ReloadViewController(_ sender:Any) {
        if let retryButton = sender as? UIButton {
            if retryButton.superview != nil {
                retryButton.superview!.removeFromSuperview()
            }
        }
        //alert(Message: "امکان تلاش مجدد نیست")
    }
    
    func showInternetDisconnection(){
        for av in self.view.subviews{
            if av.tag == 123456 {
                return
            }
        }
        let textFont = UIFont (name: "Shabnam FD", size: 13)!
        let aView = UIView(frame: CGRect(x: 0, y: -(self.view.frame.height*0.1), width: self.view.frame.width, height: self.view.frame.height*0.1))
        aView.backgroundColor = UIColor(hex: 0xD6D7D9)
        aView.tag = 123456
        self.view.addSubview(aView)
        let aLabel = UILabel(frame: CGRect(x: aView.frame.width*0.4, y: aView.frame.height*0.1, width: aView.frame.width*0.5, height: aView.frame.height*0.8))
        aLabel.text = "ارتباط با شبکه قطع است."
        aLabel.font = textFont
        aLabel.semanticContentAttribute = .forceRightToLeft
        aLabel.textAlignment = .right
        aLabel.textColor = UIColor(hex: 0xDA3A5C)
        aView.addSubview(aLabel)
        let aButton = RoundedButtonWithDarkBackground(frame: CGRect(x: aView.frame.width*0.1, y: aView.frame.height*0.3, width: aView.frame.width*0.2, height: aView.frame.height*0.4))
        aButton.setTitle("تلاش مجدد", for: .normal)
        aButton.titleLabel?.textColor = UIColor(hex: 0xF7F7F7)
        aButton.titleLabel?.font = textFont
        aButton.addTarget(self, action: #selector(ReloadViewController(_:)), for: .touchUpInside)
        aView.addSubview(aButton)
        UIView.animate(withDuration: 0.5, animations: {
            aView.frame = CGRect(x: 0, y: self.view.frame.height*0.1, width: self.view.frame.width, height: self.view.frame.height*0.1)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            UIView.animate(withDuration: 0.3, animations: {
                aView.frame = CGRect(x: 0, y: -(self.view.frame.height*0.1), width: self.view.frame.width, height: self.view.frame.height*0.1)
            }){ _ in
                aView.removeFromSuperview()
            }
        })
    }

    func subscribeToInternetDisconnection()->Disposable{
        return NetworkManager.shared.status
            .filter({$0 == CallStatus.error || $0 == CallStatus.InternalServerError})
            .subscribe(onNext: { [unowned self] innerStatus in
                if innerStatus == CallStatus.InternalServerError {
                    if (self.viewIfLoaded?.window != nil) {
                        print("Alerting Internal Error ",self)
                        self.alert(Message: "اشکال در سرور بوجود آمده است")
                    }
                }else if innerStatus == CallStatus.IncompleteData {
                    self.alert(Message: "اطلاعات این پست کامل نیست")
                }else if innerStatus == CallStatus.error {
                    self.showInternetDisconnection()
                }
                NetworkManager.shared.status = BehaviorRelay<CallStatus>(value: CallStatus.ready)
            })
    }

}
