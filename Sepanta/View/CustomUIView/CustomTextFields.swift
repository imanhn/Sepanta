//
//  CustomTextFields.swift
//  Sepanta
//
//  Created by Iman on 8/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
class EmptyTextField: UITextField {
    override func draw(_ rect: CGRect) {
    }
}

class UnderLinedTextField: UITextField {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 20, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }
}

class UnderLinedSelectableTextField: UITextField {
    override func draw(_ rect: CGRect) {
        let sizeOfTriangle = rect.height/4
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 20, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        let contextTriangle = UIGraphicsGetCurrentContext()
        contextTriangle?.setLineWidth(2.0)
        contextTriangle?.setStrokeColor((UIColor( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 )).cgColor)
        contextTriangle?.move(to: CGPoint(x: 20, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 20+sizeOfTriangle, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 20, y: self.bounds.height-5-sizeOfTriangle))
        contextTriangle?.closePath()
        contextTriangle?.fillPath()
    }
}

class UnderLinedSelectableTextFieldWithWhiteTri: UITextField {
    override func draw(_ rect: CGRect) {
        let sizeOfTriangle = rect.height/4
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.move(to: CGPoint(x: 20, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        let contextTriangle = UIGraphicsGetCurrentContext()
        contextTriangle?.setLineWidth(2.0)
        contextTriangle?.setStrokeColor((UIColor.white).cgColor)
        contextTriangle?.setFillColor((UIColor.white).cgColor)
        contextTriangle?.move(to: CGPoint(x: 20, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 20+sizeOfTriangle, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 20, y: self.bounds.height-5-sizeOfTriangle))
        contextTriangle?.closePath()
        contextTriangle?.fillPath()
    }
}



class CustomSearchBar: UITextField {
    var curvSize: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let BB = CGRect(x: 4, y: 4, width: self.bounds.width-8, height: self.bounds.height-8)
        let boundPath = UIBezierPath(roundedRect: BB, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        let shadow1 = CGRect(x: 3, y: 3, width: self.bounds.width-6, height: self.bounds.height-6)
        let shadow1Path = UIBezierPath(roundedRect: shadow1, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        let shadow2 = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let shadow2Path = UIBezierPath(roundedRect: shadow2, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(3.0)
        context?.setStrokeColor((UIColor( red: 0.99, green: 0.98, blue: 0.99, alpha: 0.5 )).cgColor)
        context?.addPath(shadow2Path)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        context?.setLineWidth(3.0)
        context?.setStrokeColor((UIColor( red: 0.968, green: 0.968, blue: 0.968, alpha: 0.5 )).cgColor)
        context?.addPath(shadow1Path)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5 )).cgColor)
        context?.addPath(boundPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        self.attributedPlaceholder = NSAttributedString(string: "جستجو",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0xD6D7D9)])
        
    }
}

class CreditCardPartNumber: UITextField {
    weak var backwardDelegate: UITextFieldDelegateWithBackward?
    override func deleteBackward() {
        backwardDelegate?.deletePressed(self)
        super.deleteBackward()
        
    }
}
