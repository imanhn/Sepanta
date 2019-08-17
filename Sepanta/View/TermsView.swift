//
//  TermsView.swift
//  Sepanta
//
//  Created by Iman on 2/21/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import UIKit

class TermsView: UIView {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    let kContent_XIB_NAME = "TermsView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func okTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kContent_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        layer.masksToBounds = false
        //layer.borderColor = UIColor(hex: 0xF7F7F7).cgColor
        layer.cornerRadius = 10
        //layer.borderWidth = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 10
        
    }
    
}
