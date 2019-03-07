//
//  AboutUsUI.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit

//extension  GetRichViewController {
class AboutUsUI {
    var delegate : AboutUsViewController!
    var submitButton = UIButton(type: .custom)
    
    init() {
    }
    
    //Create Gradient on PageView
    func showAboutUs(_ avc : AboutUsViewController) {
        self.delegate = avc

        let aFont = UIFont(name: "Shabnam-FD", size: 16)
        var cursurY : CGFloat = 0
        let marginY : CGFloat = (UIScreen.main.bounds.width / 6)  //10
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.scrollView.layer.insertSublayer(gradient, at: 0)
        self.delegate.scrollView.semanticContentAttribute = .forceRightToLeft
        
        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.delegate.scrollView.addSubview(backgroundFormView)
        self.delegate.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        cursurY = cursurY + marginY
        
        
        let logo = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/3, y: cursurY, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        logo.image = UIImage(named: "logo_shape")
        logo.contentMode = .scaleAspectFit
        self.delegate.scrollView.addSubview(logo)
        cursurY = cursurY + logo.frame.height + 0//+ marginY

        let logo_text = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width*2/5, y: cursurY, width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/10))
        logo_text.image = UIImage(named: "logo_text")
        logo_text.contentMode = .scaleAspectFit
        self.delegate.scrollView.addSubview(logo_text)
        cursurY = cursurY + logo_text.frame.height + 0//+ marginY

        let logo_slong = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width*2/5, y: cursurY, width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/10))
        logo_slong.image = UIImage(named: "logo_slong")
        logo_slong.contentMode = .scaleAspectFit
        self.delegate.scrollView.addSubview(logo_slong)
        cursurY = cursurY + logo_text.frame.height + marginY

        let sepantaLabel = UILabel(frame: CGRect(x: 20, y: cursurY, width: UIScreen.main.bounds.width-40, height: 0))
        let str1 = "سپنتا با هدف ایجاد بستری جهت استفاده جامعه از خدمات تجارت الکترونیک با سیستم های بروز این حوزه نظیر استفاده از "
        let str2 = "دستگاه های کارت خوان، کارت باشگاه مشتریان و پاساژهای الکترونیکی، ایجاد شده است." + "\n"
        let str3 = "هایپرها، فروشگاه ها و مراکز فروشی که از دستگاه کارت خوان سپنتا استفاده می کنند، همواره تخفیف های روزانه و همیشگی "
        let str4 = "خود را به مشتریانی ارائه می دهند که عضو باشگاه مشتریان سپنتا باشند. این مزیتی برای مراکز خرید است تا همیشه از "
        let str5 = "مشتریانی وفادار بهره مند شوند."
        sepantaLabel.text = str1+str2+str3+str4+str5
        let sepantaLabelHeight = sepantaLabel.text?.height(withConstrainedWidth: sepantaLabel.frame.width, font: aFont!)
        sepantaLabel.frame = CGRect(x: sepantaLabel.frame.origin.x, y: cursurY, width: sepantaLabel.frame.width, height: sepantaLabelHeight!)
        sepantaLabel.font = aFont
        sepantaLabel.textColor = UIColor(hex: 0x515152)
        //sepantaLabel.contentMode = .scaleAspectFit
        sepantaLabel.semanticContentAttribute = .forceRightToLeft
        //sepantaLabel.textAlignment = .justified
        sepantaLabel.textAlignment = .right
        sepantaLabel.numberOfLines = 0
        self.delegate.scrollView.addSubview(sepantaLabel)
        cursurY = cursurY + sepantaLabel.frame.height + marginY

        let cardImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width*2/5, y: cursurY, width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/10))
        cardImage.image = UIImage(named: "logo_slong")
        cardImage.contentMode = .scaleAspectFit
        self.delegate.scrollView.addSubview(cardImage)
        cursurY = cursurY + cardImage.frame.height + 10

        let cardLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*2/5, y: cursurY, width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/10))
        cardLabel.font = UIFont(name: "Shabnam-Bold-FD", size: 16)
        //cardLabel.textColor = UIColor(hex: 0x96336C)
        cardLabel.textColor = UIColor(hex: 0x46367B)
        cardLabel.textAlignment = .center
        cardLabel.semanticContentAttribute = .forceRightToLeft
        cardLabel.text = "کارت  IPS"
        self.delegate.scrollView.addSubview(cardLabel)
        cursurY = cursurY + cardLabel.frame.height + marginY
        
        
        let ipsLabel = UILabel(frame: CGRect(x: 20, y: cursurY, width: UIScreen.main.bounds.width-40, height: 0))
        let ipsStr1 = "کارت با بررسی نیازهای خانوار که شامل هزینه IPS خوراک، پوشاک، تفریحی و بهداشت و درمان می باشد"
        let ipsStr2 = "مراکزی را در همه زمینه های مذکور با توجه به کیفیت، قیمت اجناس و خدمات گلچین نموده و با عقد قرارداد با آن مرکز بستری را "
        let ipsStr3 = "فراهم نموده که سرپرست خانوار بتواند با شرایطی خاص از سرویس های این مراکز استفاده نمایند"
        ipsLabel.text = ipsStr1 + ipsStr2 + ipsStr3
        let ipsLabelHeight = ipsLabel.text?.height(withConstrainedWidth: ipsLabel.frame.width, font: aFont!)
        ipsLabel.frame = CGRect(x: ipsLabel.frame.origin.x, y: cursurY, width: ipsLabel.frame.width, height: ipsLabelHeight!)
        ipsLabel.font = aFont
        ipsLabel.textColor = UIColor(hex: 0x515152)
        //ipsLabel.contentMode = .scaleAspectFit
        ipsLabel.semanticContentAttribute = .forceRightToLeft
        //ipsLabel.textAlignment = .justified
        ipsLabel.textAlignment = .right
        ipsLabel.numberOfLines = 0
        self.delegate.scrollView.addSubview(ipsLabel)
        cursurY = cursurY + ipsLabel.frame.height +  marginY
        
        let aBut = RoundedButtonWithDarkBackground(type: .custom)
        aBut.setTitle("ادامه مطالعه بر روی سایت", for: .normal)
        aBut.frame = CGRect(x: UIScreen.main.bounds.width/5, y: cursurY, width: UIScreen.main.bounds.width*3/5, height: UIScreen.main.bounds.width*3/20)
        aBut.titleLabel?.font = UIFont(name: "Shabnam-Bold-FD", size: 16)
        //aBut.setAttributedTitle(NSAttributedString(attributedString: ""), for: .normal)
        self.delegate.scrollView.addSubview(aBut)
        cursurY = cursurY + aBut.frame.height + 10//marginY
        
        let siteLabel = UILabel(frame: CGRect(x: 0, y: cursurY, width: UIScreen.main.bounds.width, height: 0))
        siteLabel.text = "http://ipsepanta.ir/"
        siteLabel.font = aFont
        siteLabel.textAlignment = .center
        siteLabel.textColor = UIColor(hex: 0xD6D7D9)
        let siteLabelFont = UIFont(name: "Shabnam-FD", size: 8)
        let siteLabelHeight = siteLabel.text?.height(withConstrainedWidth: siteLabel.frame.width, font: siteLabelFont!)
        siteLabel.frame = CGRect(x: siteLabel.frame.origin.x, y: cursurY, width: siteLabel.frame.width, height: siteLabelHeight!)
        self.delegate.scrollView.addSubview(siteLabel)
        cursurY = cursurY + siteLabel.frame.height +  marginY

        self.delegate.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)

    }
    
}
