//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

import UIKit

class SignupViewController: UIViewController  {

    
    @IBOutlet weak var GenderPicker: UIPickerView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        GenderPicker.dataSource = GenderPickerDelegateSource()
        GenderPicker.delegate = GenderPickerDelegateSource()
        // Do any additional setup after loading the view, tßypically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

