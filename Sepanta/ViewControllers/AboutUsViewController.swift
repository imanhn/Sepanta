//
//  AboutUsViewController.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit

class AboutUsViewController : UIViewController,UITextFieldDelegate,Storyboarded{
    
    @IBOutlet weak var scrollView: UIScrollView!
    var aboutUsUI : AboutUsUI?
    
    weak var coordinator : AboutUsCoordinator?
    
    @IBAction func backToParent(_ sender: Any) {
        self.coordinator?.goBack()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        aboutUsUI = AboutUsUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        aboutUsUI!.showAboutUs(self)
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        print("self.coordinator : ",self.coordinator ?? "was Nil in AboutUSViewController")
        coordinator?.openButtomMenu()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("View DID Disapear!")
        self.aboutUsUI = nil
    }
}

