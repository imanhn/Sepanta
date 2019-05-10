//
//  ReportPostView.swift
//  Sepanta
//
//  Created by Iman on 2/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
//
//  RateView.swift
//  Sepanta
//
//  Created by Iman on 2/16/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import UIKit
import Alamofire

class ReportPostView: UIView {
    var descText : UITextField!
    var post_id : Int!

    init(frame: CGRect,PostID anID : Int) {
        post_id = anID
        super.init(frame: frame)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        let contentView = UIView(frame: CGRect(x: self.frame.width*0.05, y: self.frame.height*0.05, width: self.frame.width*0.9, height: self.frame.height*0.9))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(hex: 0xF7F7F7)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowRadius = 5
        self.addSubview(contentView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height/3))
        titleLabel.text = "آیا این پست دارای تخلف است؟"
        titleLabel.font = UIFont(name: "Shabnam FD", size: 13)
        titleLabel.textColor = UIColor(hex: 0x515152)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        descText = UITextField(frame: CGRect(x: 10, y: contentView.frame.height/3, width: contentView.frame.width - 20, height: contentView.frame.height*2/9))
        descText.font = UIFont(name: "Shabnam FD", size: 13)
        descText.textColor = UIColor(hex: 0x515152)
        descText.backgroundColor = UIColor.white
        descText.layer.cornerRadius = 5
        descText.layer.masksToBounds = true
        descText.textAlignment = .right
        //descText.placeholder = "   توضیحات"
        descText.attributedPlaceholder = NSAttributedString(string: "   توضیحات" , attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0xD6D7D9)])
        //descText.drawPlaceholder(in: CGRect(x: contentView.frame.width/2, y: contentView.frame.height/3, width: (contentView.frame.width/2) - 20, height: contentView.frame.height/3))
        descText.semanticContentAttribute = .forceRightToLeft
        contentView.addSubview(descText)
        
        let lineView = UIView(frame: CGRect(x: 10, y: (contentView.frame.height/3)+(contentView.frame.height*2/9)+2, width: descText.frame.width , height: 1))
        lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
        contentView.addSubview(lineView)

        
        
        let yesButton = RoundedButtonWithDarkBackground(type: .custom)
        yesButton.frame = CGRect(x: contentView.frame.width/10, y: contentView.frame.height*2/3, width: contentView.frame.width*3/10, height: contentView.frame.height/4)
        contentView.addSubview(yesButton)
        yesButton.setTitle("بلی", for: .normal)
        yesButton.setTitleColor(UIColor.white, for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        yesButton.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
        

        let noButton = RoundedButtonWithDarkBackground(type: .custom)
        noButton.frame = CGRect(x: contentView.frame.width*6/10, y: contentView.frame.height*2/3, width: contentView.frame.width*3/10, height: contentView.frame.height/4)
        contentView.addSubview(noButton)
        noButton.setTitle("خیر", for: .normal)
        noButton.setTitleColor(UIColor.white, for: .normal)
        noButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        noButton.addTarget(self, action: #selector(noTapped), for: .touchUpInside)
        

    }
    
    @objc func yesTapped(_ sender : UIButton){
        guard post_id != nil else {return}
        let aParameter = ["post_id":"\(post_id!)",
            "description":"\(descText.text!)"]
        NetworkManager.shared.run(API: "report-post", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
        self.removeFromSuperview()
    }
    
    @objc func noTapped(_ sender : UIButton){
        self.removeFromSuperview()
    }
    
}
