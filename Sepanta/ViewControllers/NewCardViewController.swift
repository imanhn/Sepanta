//
//  NewCardViewController.swift
//  Sepanta
//
//  Created by Iman on 2/10/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewCardViewController : UIViewControllerWithErrorBar,UITextFieldDelegate,UITextFieldDelegateWithBackward {
    //var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    weak var coordinator : HomeCoordinator?
    var cardNo : String = ""
    @IBOutlet weak var part1: CreditCardPartNumber!
    @IBOutlet weak var part2: CreditCardPartNumber!
    @IBOutlet weak var part3: CreditCardPartNumber!
    @IBOutlet weak var part4: CreditCardPartNumber!
    
    @IBOutlet weak var bankLogoView: UIImageView!
    
    @IBOutlet weak var submitButton: SubmitButton!
    
    @IBAction func backTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popHome()
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        self.coordinator!.pushGetRich(cardNo)
    }
    
    func handleSubmitButtonEnableOrDisable(){
        let handleSubmitStatus = Observable.combineLatest([part1.rx.text,
                                  part2.rx.text,
                                  part3.rx.text,
                                  part4.rx.text
            ])
            .subscribe(onNext: { (combinedTexts) in
                //print("combinedTexts : ",combinedTexts)
                self.cardNo = combinedTexts.reduce("", {$0 + ($1 ?? "")})
                let mappedTextToBool = combinedTexts.map{$0 != nil && $0!.count == 4}
                //print("mapped : ",mappedTextToBool)
                var tagToEdit = 101
                if mappedTextToBool[0] { tagToEdit = 102}
                if mappedTextToBool[1] { tagToEdit = 103}
                if mappedTextToBool[2] { tagToEdit = 104}
                //print("Tag to Edit : ",tagToEdit)
                let allTextFilled = mappedTextToBool.reduce(true, {$0 && $1})
                if  allTextFilled {
                    //self.view.endEditing(true)
                }else {
                    if let nextResponder = self.part1.superview?.viewWithTag(tagToEdit) {
                        if (self.part1.text?.count)! > 0 {
                            DispatchQueue.main.async {
                                nextResponder.becomeFirstResponder()
                            }
                        }
                    }
                }
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
            )
        //handleSubmitStatus.disposed(by: self.myDisposeBag)
        disposeList.append(handleSubmitStatus)
    }
    
    func deletePressed(_ sender : Any){
        if let textField = sender as? UITextField{
            if (textField.text?.count)! > 0 {
                textField.text = textField.text?.slice(From: 0, To: (textField.text?.count)!-1)
                return
            } else {
                if textField.tag == 101 {return}
                let tagToEdit = textField.tag - 1
                if let nextResponder = self.part1.superview?.viewWithTag(tagToEdit) {
                    if let previousTextField = nextResponder as? UITextField {
                        if (previousTextField.text ?? "").count > 2 {
                            previousTextField.text = previousTextField.text!.slice(From: 0, To: 2)
                        }
                        DispatchQueue.main.async {
                            nextResponder.becomeFirstResponder()
                        }
                    }
                //print("Here it comes the tricky part")
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 4
    }
    
    func initUI(){
        part1.delegate = self
        part1.backwardDelegate = self
        part1.tag = 101
        
        part2.delegate = self
        part2.backwardDelegate = self
        part2.tag = 102
        
        part3.delegate = self
        part3.backwardDelegate = self
        part3.tag = 103
        
        part4.delegate = self
        part4.backwardDelegate = self
        part4.tag = 104
        submitButton.setDisable()
        handleSubmitButtonEnableOrDisable()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
}
