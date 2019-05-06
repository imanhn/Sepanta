//
//  FilterView.swift
//  Sepanta
//
//  Created by Iman on 2/16/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//


import UIKit


class FilterView: UIView {
    var filterType = UnderLinedSelectableTextFieldWithWhiteTri(frame: .zero)
    var filterValue = UnderLinedSelectableTextFieldWithWhiteTri(frame: .zero)
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
        
        filterType = UnderLinedSelectableTextFieldWithWhiteTri(frame: CGRect(x: marginX, y: 0, width: contentView.frame.width-2*marginX, height: contentView.frame.height/3))
        filterType.font = UIFont(name: "Shabnam FD", size: 16)
        filterType.textColor = UIColor.white
        filterType.adjustsFontSizeToFitWidth = true
        filterType.textAlignment = .center
        filterType.tag = 1
        contentView.addSubview(filterType)
        
        filterValue = UnderLinedSelectableTextFieldWithWhiteTri(frame: CGRect(x: marginX, y: contentView.frame.height/3, width: contentView.frame.width-2*marginX, height: contentView.frame.height/3))
        filterValue.font = UIFont(name: "Shabnam FD", size: 16)
        filterValue.adjustsFontSizeToFitWidth = true
        filterValue.textColor = UIColor.white
        filterValue.textAlignment = .center
        filterType.tag = 2
        contentView.addSubview(filterValue)
        
        submitButton.frame = CGRect(x: contentView.frame.width/4, y: (contentView.frame.height*2/3)+(contentView.frame.height/24), width: contentView.frame.width/2, height: contentView.frame.height/4)
        contentView.addSubview(submitButton)
        submitButton.setTitle("اعمال تغییرات", for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)        
        submitButton.setEnable()
    }
    
}
