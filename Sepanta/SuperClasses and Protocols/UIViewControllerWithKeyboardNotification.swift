//
//  KeyboardNotificationLoginVC.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
class UIViewControllerWithKeyboardNotificationWithErrorBar : UIViewControllerWithErrorBar {
    @objc func keyboardWillChange(notification : Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            print("Keyboard Rect is Empty!")
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
    }
    
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
}
