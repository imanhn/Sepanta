//
//  ContactUSViewController.swift
//  Sepanta
//
//  Created by Iman on 2/9/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//
import UIKit
import RxSwift
import Alamofire

class ContactUSViewController: UIViewControllerWithKeyboardNotificationWithErrorBar,UITextFieldDelegate {
    var myDisposeBag = DisposeBag()
    var contactUSUI : ContactUSUI?
    weak var coordinator : HomeCoordinator?
    @IBOutlet weak var panelView: TabbedViewWithWhitePanel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var showContactInfo: UIButton!
    @IBOutlet weak var showFeedback: UIButton!

    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var notBadButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    @IBAction func goodTapped(_ sender: Any) {
        if goodButton.tag == 1 {
            goodButton.tag = 0
            notBadButton.tag = 0
            badButton.tag = 0
        }else{
            goodButton.tag = 1
            notBadButton.tag = 0
            badButton.tag = 0
        }
        updateEmojis()
    }
    @IBAction func notBadTapped(_ sender: Any) {
        if notBadButton.tag == 1 {
            goodButton.tag = 0
            notBadButton.tag = 0
            badButton.tag = 0
        }else{
            goodButton.tag = 0
            notBadButton.tag = 1
            badButton.tag = 0
        }
        updateEmojis()
    }
    @IBAction func badTapped(_ sender: Any) {
        if badButton.tag == 1 {
            goodButton.tag = 0
            notBadButton.tag = 0
            badButton.tag = 0
        }else{
            goodButton.tag = 0
            notBadButton.tag = 0
            badButton.tag = 1
        }
        updateEmojis()
    }
    
    func updateEmojis(){
        if goodButton.tag == 1 { goodButton.setImage(UIImage(named: "icon_emoji_01_color"), for: .normal) } else { goodButton.setImage(UIImage(named: "icon_emoji_01"), for: .normal) }
        if notBadButton.tag == 1 { notBadButton.setImage(UIImage(named: "icon_emoji_02_color"), for: .normal) } else { notBadButton.setImage(UIImage(named: "icon_emoji_02"), for: .normal) }
        if badButton.tag == 1 { badButton.setImage(UIImage(named: "icon_emoji_03_color"), for: .normal) } else { badButton.setImage(UIImage(named: "icon_emoji_03"), for: .normal) }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        contactUSUI!.disposeList.forEach({$0.dispose()})
        contactUSUI = nil
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    @IBAction func showContactInfoTapped(_ sender: Any) {
        self.panelView.tabJust = .Right
        self.panelView.setNeedsDisplay()
        self.contactUSUI!.showContactInfo()
    }
    
    @IBAction func showFeedbackFromTapped(_ sender: Any) {
        self.panelView.tabJust = .Left
        self.panelView.setNeedsDisplay()
        self.contactUSUI!.showFeedbackForm()
    }
    
    func gradientMainView(){
        let gradient = CAGradientLayer()
        gradient.frame = self.mainView.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        mainView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientMainView()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        contactUSUI = ContactUSUI(self)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        contactUSUI!.showContactInfo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
