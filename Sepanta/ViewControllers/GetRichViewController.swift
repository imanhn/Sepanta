//
//  GetRichViewController.swift
//  Sepanta
//
//  Created by Iman on 12/14/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class GetRichViewController : UIViewController,UITextFieldDelegate,Storyboarded{
    var awareCheckButton = UIButton(type: .custom)
    var termsCheckButton = UIButton(type: .custom)
    var leftButton = UIButton(type: .custom)
    var rightButton = UIButton(type: .custom)
    var rightFormView = RightTabbedViewWithWhitePanel()
    var leftFormView = LeftTabbedViewWithWhitePanel()
    var termsLabel : UILabel?
    var awareLabel : UILabel?
    var termsAgreed : Bool = false
    var shopAwareness : Bool = false

    @IBOutlet weak var scrollView: UIScrollView!
    var contentView = UIView()
    weak var coordinator : GetRichCoordinator?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        resellerRequestTapped(nil)
        
    }
    @IBAction func menuClicked(_ sender: Any) {
        print("self.coordinator : ",self.coordinator ?? "was Nil in GetRichViewController")
        self.coordinator!.openButtomMenu()
    }
    
}
