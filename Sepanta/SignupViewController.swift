//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

import UIKit

class SignupViewController: UIViewController ,UIPickerViewDataSource ,UIPickerViewDelegate  {

    
    @IBOutlet weak var GenderPicker: UIPickerView!
    let genderTypes : Array = ["زن","مرد"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       // print("Label Selected row ",row)
        var currentText : String = "نامشخص";
        if row >= 0 && row < pickerView.numberOfRows(inComponent: 0) {
          currentText = genderTypes[row]
        }
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "B Yekan", size: 20)
        label.text = currentText
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderTypes.count
    }
    override func viewDidLoad() {
    
        super.viewDidLoad()

        GenderPicker.dataSource = self //GenderPickerDelegateSource()
        GenderPicker.delegate = self//GenderPickerDelegateSource()
        GenderPicker.selectRow(1, inComponent: 0, animated: true)
        // Do any additional setup after loading the view, tßypically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

