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
import SafariServices

class ContactUSUI : NSObject , UITextFieldDelegate,SFSafariViewControllerDelegate {
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
        
        let buttonHeight = self.delegate.contentView.frame.height / 7
        let textFieldWidth = (self.delegate.contentView.bounds.width) - (2 * marginX)
        var shopView = UIView()
        let sepantaText = "مجموعه سپنتا یک استات آپ مبتنی بر ارائه سرویس های مرتبط با باشگاه مشتریان است. در مجموعه سپنتا فروشگاه ها و خریدران کالا و خدمات امکان یافتن منابع مورد نیاز را دارد"
        (shopView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "icon_profile_05",  LabelText: sepantaText,Lines : 3)
        cursurY = cursurY + shopView.frame.height + marginY/2
        self.delegate.contentView.addSubview(shopView)

        
        
        let sepantaAddress = "تهران میدان آرژانتین خیابان الوند نبش الوند ۳۳ شرقی پلاک ۴۵ واحد ۶"
        
        var addressView = UIView()
        (addressView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "icon_profile_06",  LabelText: sepantaAddress,Lines : 2)
        cursurY = cursurY + addressView.frame.height + marginY/2
        self.delegate.contentView.addSubview(addressView)

        var telView = UIView()
        (telView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "icon_profile_07",  LabelText: "۰۲۱-۴۵۲۲۷",Lines: 1)
        cursurY = cursurY + telView.frame.height + marginY/2
        self.delegate.contentView.addSubview(telView)
         
        
        var webView = UIView()
        var aLab = UILabel()
        (webView,aLab) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "web",  LabelText: "https://www.sepantaclubs.com",Lines: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(openWebSite))
        aLab.isUserInteractionEnabled = true
        aLab.addGestureRecognizer(tap)
        cursurY = cursurY + webView.frame.height + marginY/2
        self.delegate.contentView.addSubview(webView)
        
        var emailView = UIView()
        (emailView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "black-back-closed-envelope-shape",  LabelText: "info@sepantaclubs.com",Lines: 1)
        cursurY = cursurY + emailView.frame.height + marginY/2
        self.delegate.contentView.addSubview(emailView)

        
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
    
    
    @objc func submitFeedBack(_ sender : Any){
        self.delegate.view.endEditing(true)
        let aParameter = ["title":self.subjectText.text ?? "",
                          "body":self.commentText.text ?? ""]
        (ApiClient().request(API: "contact", aMethod: HTTPMethod.post, Parameter: aParameter) as Observable<GenericNetworkResponse>)
            .subscribe(onNext: { genericRes in
                print("GENERIC : ",genericRes)
                
                if genericRes.status == "successful" {
                    self.subjectText.text = ""
                    self.commentText.text = ""
                    self.delegate.alert(Message: genericRes.message ?? "نظر شما ارسال گردید")
                }else{
                    self.delegate.alert(Message: "متاسفانه خطایی در هنگام ثبت نظر شما اتفاق افتاد")
                }
            }).disposed(by: self.delegate.myDisposeBag)
    }
    
    @objc func openWebSite(){
        let url = URL(string: "https://www.sepantaclubs.com")!
        let safariVC = SFSafariViewController(url: url)
        self.delegate.coordinator!.navigationController.pushViewController(safariVC, animated: true)
        safariVC.delegate = self
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: false, completion: {})
        self.delegate.coordinator!.popOneLevel()
    }

}
