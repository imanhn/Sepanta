//
//  GenderPickerDelegateSource.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class GenderPickerDelegateSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let genderTypes: Array = ["زن", "مرد"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row > 0 && row < 2 else {
            return "نامشخص"
        }
        return genderTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
}
