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
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowRadius = 2
        self.addSubview(contentView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height/3))
        titleLabel.text = "آیا می خواهید برای این پست تخلف گزارش نمایید؟"
        titleLabel.font = UIFont(name: "Shabnam FD", size: 13)
        titleLabel.textColor = UIColor(hex: 0x515152)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        descText = UITextField(frame: CGRect(x: contentView.frame.width/3, y: contentView.frame.height/3, width: contentView.frame.width/3, height: contentView.frame.height/3))
        descText.font = UIFont(name: "Shabnam FD", size: 13)
        descText.textColor = UIColor(hex: 0x515152)
        contentView.addSubview(descText)
        
        let yesButton = SubmitButton(type: .custom)
        yesButton.frame = CGRect(x: contentView.frame.width/5, y: contentView.frame.height*2/3, width: contentView.frame.width/5, height: contentView.frame.height/4)
        contentView.addSubview(yesButton)
        yesButton.setTitle("بلی", for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        yesButton.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
        yesButton.setEnable()

        let noButton = SubmitButton(type: .custom)
        noButton.frame = CGRect(x: contentView.frame.width*3/5, y: contentView.frame.height*2/3, width: contentView.frame.width/5, height: contentView.frame.height/4)
        contentView.addSubview(noButton)
        noButton.setTitle("خیر", for: .normal)
        noButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        noButton.addTarget(self, action: #selector(noTapped), for: .touchUpInside)
        noButton.setEnable()

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
