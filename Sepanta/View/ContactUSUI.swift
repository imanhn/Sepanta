//
//  ContactUSUI.swift
//  Sepanta
//
//  Created by Iman on 2/9/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
//
//  GetRichUI.swift
//  Sepanta
//
//  Created by Iman on 12/15/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

class ContactUSUI : NSObject , UITextFieldDelegate {
    var delegate : ContactUSViewController!
    var views = Dictionary<String,UIView>()
    var texts = Dictionary<String,UITextField>()
    var labels = Dictionary<String,UILabel>()
    var buttons = Dictionary<String,UIButton>()
    var submitButton = UIButton(type: .custom)
    var disposeList = [Disposable]()
    var subjectText = UITextField(frame: .zero)
    var commentText = UITextField(frame: .zero)
    var subjectView = UIView(frame: .zero)
    var commentView = UIView(frame: .zero)
    var cursurY : CGFloat = 0
    let marginY : CGFloat = 10
    let marginX : CGFloat = 20

    init(_ vc : ContactUSViewController) {
        self.delegate = vc
        super.init()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //BuildRow set 11 for tag of selectable textfield (See BuildRow function)
        if textField.tag == 11 {
            return false
            
        }else{
            // edittingView is set for keyboard notification manageing facility to find out if we should move the keyboard up or not!
            self.delegate.edittingView = textField
            return true
        }
    }
    //Create Gradient on PageView
    func showContactInfo() {
        
        self.delegate.contentView.subviews.forEach({$0.removeFromSuperview()})
        disposeList.forEach({$0.dispose()})
        self.delegate.showContactInfo.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        self.delegate.showFeedback.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        cursurY = 0

        /*
        
        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.delegate.mainView.addSubview(backgroundFormView)
        */
        
        //views["rightFormView"] = TabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 2))
        //self.delegate.panelView.backgroundColor = UIColor.clear
        
        let buttonHeight = self.delegate.contentView.frame.height / 7
        let textFieldWidth = (self.delegate.contentView.bounds.width) - (2 * marginX)

        let sepantaText = "مجموعه سپنتا یک استات آپ مبتنی بر ارائه سرویس های مرتبط با باشگاه مشتریان است. در مجموعه سپنتا فروشگاه ها و خریدران کالا و خدمات امکان یافتن منابع مورد نیاز را دارد"
        (views["shopView"],labels["shopText"]) = buildALabelView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_05",  LabelText: sepantaText,Lines : 3)
        cursurY = cursurY + views["shopView"]!.frame.height + marginY/2
        self.delegate.contentView.addSubview(views["shopView"]!)

        let sepantaAddress = "تهران میدان آرژانتین خیابان الوند نبش الوند ۳۳ شرقی پلاک ۴۵ واحد ۶"
        (views["addressView"],labels["addressText"]) = buildALabelView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_06",  LabelText: sepantaAddress,Lines : 2)
        cursurY = cursurY + views["addressView"]!.frame.height + marginY/2
        self.delegate.contentView.addSubview(views["addressView"]!)

        (views["telView"],labels["telText"]) = buildALabelView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07",  LabelText: "۰۲۱-۴۵۲۲۷",Lines: 1)
        cursurY = cursurY + views["telView"]!.frame.height + marginY/2
        self.delegate.contentView.addSubview(views["telView"]!)

        (views["webView"],labels["webText"]) = buildALabelView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "web",  LabelText: "www.ipsepanta.ir",Lines: 1)
        cursurY = cursurY + views["webView"]!.frame.height + marginY/2
        self.delegate.contentView.addSubview(views["webView"]!)

        (views["emailView"],labels["emailText"]) = buildALabelView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape",  LabelText: "info@ipsepanta.ir",Lines: 1)
        cursurY = cursurY + views["emailView"]!.frame.height + marginY/2
        self.delegate.contentView.addSubview(views["emailView"]!)

        
        cursurY = cursurY + buttonHeight + marginY
        
    }
    
    func showFeedbackForm() {
        
        //print("Card Request  : ",self.delegate.panelView,"  SuperView : ",self.delegate.panelView.superview ?? "Nil")
        
        disposeList.forEach({$0.dispose()})
        self.delegate.contentView.subviews.forEach({$0.removeFromSuperview()})
        self.delegate.showContactInfo.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        self.delegate.showFeedback.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        cursurY = 0
        let buttonHeight = self.delegate.panelView.getHeight()
        let textFieldWidth = (self.delegate.contentView.bounds.width) - (2 * marginX)

        let subjectRect = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight)
        (subjectView,subjectText) = subjectRect.buildARowView(Image: "", Selectable: false, PlaceHolderText: "موضوع")
        self.delegate.contentView.addSubview(subjectView)
        cursurY = cursurY + buttonHeight + marginY
        
        let commentRect = CGRect(x: marginX, y: cursurY, width: textFieldWidth , height: buttonHeight)
        (commentView,commentText) = commentRect.buildARowView(Image: "", Selectable: false, PlaceHolderText: "توضیحات")
        self.delegate.contentView.addSubview(commentView)
        cursurY = cursurY + buttonHeight + marginY
        
        
        
        submitButton = SubmitButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        submitButton.setTitle("ارسال", for: .normal)
        submitButton.addTarget(self, action: #selector(submitFeedBack), for: .touchUpInside)
        self.delegate.contentView.addSubview(submitButton)
        handleSubmitButtonEnableOrDisable()
        
        
    }
    
    func handleSubmitButtonEnableOrDisable(){
        Observable.combineLatest([commentText.rx.text,
                                  subjectText.rx.text
            ])
            .subscribe(onNext: { (combinedTexts) in
                //print("combinedTexts : ",combinedTexts)
                let mappedTextToBool = combinedTexts.map{$0 != nil && $0!.count > 0}
                //print("mapped : ",mappedTextToBool)
                let allTextFilled = mappedTextToBool.reduce(true, {$0 && $1})
                if allTextFilled {
                    if !self.submitButton.isEnabled {
                        self.submitButton.setEnable()
                    }
                }else{
                    if self.submitButton.isEnabled {
                        self.submitButton.setDisable()
                    }
                }
            }
            ).disposed(by: self.delegate.myDisposeBag)
    }
    
    func buildALabelView(CGRect rect : CGRect,Image anImageName : String,LabelText aStr : String,Lines noLines : Int)->(UIView?,UILabel?){
        let aView = UIView(frame: rect)
        /*let lineView = UIView(frame: CGRect(x: 0, y: rect.height-1, width: rect.width, height: 1))
        lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
        aView.addSubview(lineView)
        */
        aView.backgroundColor = UIColor.white
        let icondim = rect.height / 3
        let spaceIconText : CGFloat = 20
        let imageRect = CGRect(x: (rect.width-icondim), y: (rect.height - icondim)/2, width: icondim, height: icondim)
        let anIcon = UIImageView(frame: imageRect)
        anIcon.image = UIImage(named: anImageName)
        anIcon.contentMode = .scaleAspectFit
        let aText = UILabel(frame: CGRect(x: 0, y: 0, width: (rect.width-icondim-spaceIconText), height: rect.height))
        
        if noLines == 3 {
            aText.font = UIFont(name: "Shabnam-FD", size: 12)
        }else if noLines == 2 {
            aText.font = UIFont(name: "Shabnam-FD", size: 12)
        }else if noLines == 1 {
            aText.font = UIFont(name: "Shabnam-FD", size: 14)
        }
        aText.adjustsFontSizeToFitWidth = true
        aText.textColor = UIColor(hex: 0x515152)
        aText.textAlignment = .right
        aText.text = aStr
        aText.numberOfLines = noLines
        
        //aText.delegate = self
        aView.addSubview(aText)
        aView.addSubview(anIcon)
        
        return (aView,aText)
    }
    
    

    
    @objc func submitFeedBack(_ sender : Any){
        self.delegate.view.endEditing(true)
        let aParameter = ["title":self.subjectText.text ?? "",
                          "body":self.commentText.text ?? ""]
        NetworkManager.shared.run(API: "contact", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        let contactDisp = NetworkManager.shared.contactSendingSuccessful
            .filter({$0 != ToggleStatus.UNKNOWN})
            .subscribe(onNext: { aStatus in
                if aStatus == ToggleStatus.YES {
                    let aMessage = NetworkManager.shared.message
                    self.subjectText.text = ""
                    self.commentText.text = ""
                    self.delegate.alert(Message: aMessage)
                    NetworkManager.shared.contactSendingSuccessful.accept(ToggleStatus.UNKNOWN)
                }else if aStatus == ToggleStatus.NO {
                    self.delegate.alert(Message: "متاسفانه خطایی در هنگام ثبت نظر شما اتفاق افتاد")
                    NetworkManager.shared.contactSendingSuccessful.accept(ToggleStatus.UNKNOWN)
                }
            })
        contactDisp.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(contactDisp)
    }
    

}
