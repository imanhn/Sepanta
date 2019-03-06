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
    var contentView = UIView()
    weak var coordinator : GetRichCoordinator?
    weak var getRichUI : GetRichUI?
    func setupUI() {
        getRichUI = GetRichUI(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setupUI()
        
    }
    @IBAction func menuClicked(_ sender: Any) {
        print("self.coordinator : ",self.coordinator)
        self.coordinator!.openButtomMenu()
    }
    
}
