//
//  KeyboardNotificationLoginVC.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
enum ViewStatus {
    case MovedUp
    case Normal
}

class UIViewControllerWithKeyboardNotificationWithErrorBar : UIViewControllerWithErrorBar {
    var edittingView : UITextField!
    var viewState = ViewStatus.Normal
    @objc func keyboardWillChange(notification : Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            //print("Keyboard Rect is Empty!")
            return
        }
        if edittingView != nil {
            let frame = edittingView.convert(edittingView.frame, to:nil)
            //print("Origin Y : ",frame.origin.y)
            if frame.origin.y < (keyboardRect.height * 1.2) && viewState == ViewStatus.Normal {
                //print("We do not move View in this case!")
                return
            }
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
            viewState = ViewStatus.MovedUp
        }else if viewState != ViewStatus.Normal {
            view.frame.origin.y = 0
            viewState = ViewStatus.Normal
        }
    }
    
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        registerKeyboardNotifications()
    }
}
