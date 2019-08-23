//
//  RateView.swift
//  Sepanta
//
//  Created by Iman on 2/16/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import UIKit
import Alamofire

class RateView: UIView {

    var stars: [UIButton] = [UIButton]()
    var currentRate: Int = 1
    var shop_id: Int = 0

    init(frame: CGRect, ShopID anID: Int) {
        super.init(frame: frame)
        shop_id = anID
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

    func commonInit() {
        let contentView = UIView(frame: CGRect(x: self.frame.width*0.05, y: self.frame.height*0.05, width: self.frame.width*0.9, height: self.frame.height*0.9))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(hex: 0xDA3A5C)//UIColor(hex: 0xF7F7F7)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowRadius = 2
        self.addSubview(contentView)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height/3))
        titleLabel.text = "لطفاْ امتیاز خود را وارد فرمایید"
        titleLabel.font = UIFont(name: "Shabnam-Bold-FD", size: 13)
        titleLabel.textColor = UIColor.white//UIColor(hex: 0x515152)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        let starView = UIView(frame: CGRect(x: contentView.frame.width/3, y: contentView.frame.height/3, width: contentView.frame.width/3, height: contentView.frame.height/3))
        contentView.addSubview(starView)

        stars.append(createStar(No: 1, Parent: starView))
        stars.append(createStar(No: 2, Parent: starView))
        stars.append(createStar(No: 3, Parent: starView))
        stars.append(createStar(No: 4, Parent: starView))
        stars.append(createStar(No: 5, Parent: starView))

        let submitButton = UIButton(type: .custom)
        submitButton.frame = CGRect(x: contentView.frame.width/3, y: contentView.frame.height*2/3, width: contentView.frame.width/3, height: (contentView.frame.height/3)-3)
        submitButton.backgroundColor = UIColor(hex: 0xFFFFFF)
        submitButton.setTitleColor(UIColor(hex: 0xDA3A5C), for: .normal)
        submitButton.layer.cornerRadius = 5
        submitButton.semanticContentAttribute = .forceRightToLeft
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.borderWidth = 1
        submitButton.layer.masksToBounds = true
        submitButton.setImage(UIImage(named: "icon_tick_dark"), for: .normal)
        submitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: frame.height/2, bottom: 0, right: 0)
        submitButton.setTitle("ثبت امتیاز", for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        contentView.addSubview(submitButton)
    }

    @objc func submitTapped(_ sender: UIButton) {
        let aParameter = ["shop_id": "\(shop_id)",
            "rate": "\(currentRate)"]
        NetworkManager.shared.run(API: "rating", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
        self.removeFromSuperview()
    }

    @objc func starTapped(_ sender: UIButton) {
        self.currentRate = sender.tag
        print("Current Rate : ", self.currentRate)
        stars.forEach({$0.setImage(UIImage(named: "icon_star_gray"), for: .normal)})
        for i in stride(from: sender.tag, to: 0, by: -1) {
            stars[i-1].setImage(UIImage(named: "icon_star_on"), for: .normal)
            //print("i : ",i)
        }
    }

    func createStar(No no: CGFloat, Parent starView: UIView ) -> UIButton {
        let star = UIButton(type: .custom)
        star.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        star.frame = CGRect(x: (5-no)*(starView.frame.width/5), y: 0, width: starView.frame.width/5, height: starView.frame.height)
        star.tag = Int(no)
        star.setImage(UIImage(named: "icon_star_gray"), for: .normal)
        star.setImage(UIImage(named: "icon_star_on"), for: .selected)
        if no == 1 { star.setImage(UIImage(named: "icon_star_on"), for: .normal)}
        starView.addSubview(star)
        return star
    }
}
