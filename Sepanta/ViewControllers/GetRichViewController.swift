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
    
    func setupUI() {
        //Create Gradient on PageView
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        scrollView.layer.insertSublayer(gradient, at: 0)        
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
