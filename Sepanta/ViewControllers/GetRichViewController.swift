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
   
    @IBOutlet weak var scrollView: UIScrollView!
    var getRichUI : GetRichUI?
    
    weak var coordinator : HomeCoordinator?

    @objc func cardRequestTapped(_ sender : Any) {
        getRichUI!.showCardRequest(self)
    }
    @objc func resellerRequestTapped(_ sender : Any) {
        getRichUI!.showResellerRequest(self)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getRichUI = GetRichUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        getRichUI!.showResellerRequest(self)
        //resellerRequestTapped(nil)
        
    }
    @IBAction func menuClicked(_ sender: Any) {
        print("self.coordinator : ",self.coordinator ?? "was Nil in GetRichViewController")
        self.coordinator!.openButtomMenu()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("View DID Disapear!")
        self.getRichUI = nil
    }
}
