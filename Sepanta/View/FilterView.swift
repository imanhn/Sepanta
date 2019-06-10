//
//  FilterView.swift
//  Sepanta
//
//  Created by Iman on 2/16/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//


import UIKit


class FilterView: UIView {
    var searchFilter = UnderLinedTextField(frame: .zero)
    var sortFilter = UnderLinedSelectableTextFieldWithWhiteTri(frame: .zero)
    var submitButton = FilterButton(type: .custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        let marginX : CGFloat = 20
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        contentView.backgroundColor = UIColor(hex: 0xDA3A5C)
        self.addSubview(contentView)
        
        searchFilter = UnderLinedTextField(frame: CGRect(x: marginX, y: 0, width: contentView.frame.width-2*marginX, height: contentView.frame.height/3))
        searchFilter.font = UIFont(name: "Shabnam FD", size: 16)
        searchFilter.textColor = UIColor.white
        searchFilter.attributedPlaceholder = NSAttributedString(string: "جست و جو",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        searchFilter.adjustsFontSizeToFitWidth = true
        searchFilter.textAlignment = .center
        contentView.addSubview(searchFilter)
        
        sortFilter = UnderLinedSelectableTextFieldWithWhiteTri(frame: CGRect(x: marginX, y: contentView.frame.height/3, width: contentView.frame.width-2*marginX, height: contentView.frame.height/3))
        sortFilter.font = UIFont(name: "Shabnam FD", size: 16)
        sortFilter.adjustsFontSizeToFitWidth = true
        sortFilter.textColor = UIColor.white
        sortFilter.tag = 11
        sortFilter.textAlignment = .center
        contentView.addSubview(sortFilter)
        
        submitButton.frame = CGRect(x: contentView.frame.width/4, y: (contentView.frame.height*2/3)+(contentView.frame.height/24), width: contentView.frame.width/2, height: contentView.frame.height/4)
        contentView.addSubview(submitButton)
        submitButton.setTitle("اعمال تغییرات", for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)        
        submitButton.setEnable()
    }
    
}
