//
//  NewCardView.swift
//  Sepanta
//
//  Created by Iman on 2/10/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import UIKit

class NewCardView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    let kContent_XIB_NAME = "NewCardView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle.main.loadNibNamed(kContent_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        layer.masksToBounds = false
        //layer.borderColor = UIColor(hex: 0xF7F7F7).cgColor
        layer.cornerRadius = 5
        //layer.borderWidth = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 2
        
    }
}