//
//  RadioView.swift
//  Sepanta
//
//  Created by Iman on 8/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RadioView : UIView {
    var labels : [String] = [String]()
    var checkButtons : [UIButton] = [UIButton]()
    var selectedItem = BehaviorRelay(value: 0)
    
    init(frame: CGRect, items : [String]) {
        super.init(frame: frame)
        labels = items
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // This is to estimate font size
        // First it finds available space for labels then estimates a font size
        let buttonDim = (rect.height * 2 / 5)
        var labelFont = UIFont(name: "Shabnam-FD", size: 16)!
        let numOfSpaces = (self.labels.count * 3 ) + 1
        let widthOfEachSpace = (buttonDim / 2)
        var totalLabelsWidth : CGFloat = 0
        var marginX : CGFloat = 0
        for fontSize in [16,15,14,13,12,11,10] {
            //print("Checking Font : \(fontSize)")
            labelFont = UIFont(name: "Shabnam-FD", size: CGFloat(fontSize))!
            totalLabelsWidth = self.labels.reduce(0.0, {totalWidth, aString in
                totalWidth + aString.width(withConstrainedHeight: buttonDim, font: labelFont)
            })
            let totalRadioViewWidth = totalLabelsWidth + (widthOfEachSpace * CGFloat(numOfSpaces))
            //print(" comparing \(totalRadioViewWidth) \(rect.width) result : \(totalRadioViewWidth < rect.width)")
            if totalRadioViewWidth < rect.width {
                marginX = (rect.width - totalRadioViewWidth) / 2
                break
            }
        }
        var cursurX : CGFloat = marginX
        let cursurY : CGFloat = (rect.height - buttonDim) / 2
        for i in (0..<labels.count) {
            let aCheckButton = UIButton(type: .custom)
            checkButtons.append(aCheckButton)
            aCheckButton.frame = CGRect(x: cursurX, y: cursurY, width: buttonDim, height: buttonDim)
            if (i == 0) {
                aCheckButton.setImage(UIImage(named: "radioChecked"), for: .normal)
            } else {
                aCheckButton.setImage(UIImage(named: "radioUnChecked"), for: .normal)
            }
            aCheckButton.tag = i
            aCheckButton.addTarget(self, action: #selector(radioItemSelected(_:)), for: .touchUpInside)
            self.addSubview(aCheckButton)
            cursurX += widthOfEachSpace + buttonDim
            
            let labelWidth = labels[i].width(withConstrainedHeight: buttonDim, font: labelFont)
            let aLabel = UILabel(frame: CGRect(x: cursurX, y: cursurY, width: labelWidth, height: buttonDim))
            aLabel.text = labels[i]
            aLabel.font = labelFont
            aLabel.adjustsFontSizeToFitWidth = true
            aLabel.textAlignment = .center
            aLabel.textColor = UIColor(hex: 0x515152)
            cursurX += (widthOfEachSpace * 2) + labelWidth
            self.addSubview(aLabel)
        }
    }
    
    @objc func radioItemSelected(_ sender : Any) {
        if let aRadioButton = sender as? UIButton {
            if aRadioButton.tag == self.selectedItem.value { return }
            self.selectedItem.accept(aRadioButton.tag)
            for aButton in checkButtons {
                if aButton.tag == self.selectedItem.value {
                    aButton.setImage(UIImage(named: "radioChecked"), for: .normal)
                } else {
                    aButton.setImage(UIImage(named: "radioUnChecked"), for: .normal)
                }
            }
        }
    }
}
