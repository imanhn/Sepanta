//
//  CustomWidgets.swift
//  Sepanta
//
//  Created by Iman on 11/12/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class UnderLinedTextField: UITextField {
    override func draw(_ rect: CGRect) {
        print("rect : ",rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 20, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
}

class TabbedButton: UIButton {
    var curvSize : CGFloat = 10;
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let downScaling : CGAffineTransform = CGAffineTransform(scaleX: 1, y: 0.9);
        let bezPath = UIBezierPath(roundedRect: self.bounds.applying(downScaling), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
}

class RightTabbedView: UIView {
    var curvSize : CGFloat = 10;
    let movRight : CGFloat = 5;
    let viewToButtonRatio : CGFloat = 5;
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        
        context?.move(to: CGPoint(x: curvSize, y: self.bounds.height/viewToButtonRatio))
        /* // Curv at the middle of buttons-Tab page foot!
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-curvSize, y: self.bounds.height/viewToButtonRatio))
        context?.addQuadCurve(to: CGPoint(x: (self.bounds.width/2), y: (self.bounds.height/viewToButtonRatio)-curvSize), control: CGPoint(x: (self.bounds.width/2), y: self.bounds.height/viewToButtonRatio))
        */
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)+movRight, y: self.bounds.height/viewToButtonRatio))
        
        context?.addLine(to: CGPoint(x: movRight+self.bounds.width/2, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: movRight+self.bounds.width/2+curvSize, y: 0), control: CGPoint(x: (movRight+self.bounds.width/2), y: 0))
        
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-2*curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-2*curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 2*curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-2*curvSize), control: CGPoint(x: 0, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 0, y: self.bounds.height/viewToButtonRatio+curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: self.bounds.height/viewToButtonRatio), control: CGPoint(x: 0, y: self.bounds.height/viewToButtonRatio))
        
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }
}

class LeftTabbedView: UIView {
    var curvSize : CGFloat = 10;
    let movLeft : CGFloat = 5;
    let viewToButtonRatio : CGFloat = 6.6667
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        
        context?.move(to: CGPoint(x: curvSize, y: 0))
        
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-curvSize-movLeft, y: 0))
        context?.addQuadCurve(to: CGPoint(x: (self.bounds.width/2)-movLeft, y: curvSize), control: CGPoint(x: (self.bounds.width/2)-movLeft, y: 0))

        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-movLeft, y: self.bounds.height/viewToButtonRatio - curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width/2+curvSize-movLeft, y: self.bounds.height/viewToButtonRatio), control: CGPoint(x: (self.bounds.width/2)-movLeft, y: self.bounds.height/viewToButtonRatio))

        context?.addLine(to: CGPoint(x: (self.bounds.width)-curvSize, y: self.bounds.height/viewToButtonRatio))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: self.bounds.height/viewToButtonRatio+curvSize), control: CGPoint(x: self.bounds.width, y: self.bounds.height/viewToButtonRatio))

        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-2*curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-2*curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))

        context?.addLine(to: CGPoint(x: 2*curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-2*curvSize), control: CGPoint(x: 0, y: self.bounds.height))

        context?.addLine(to: CGPoint(x: 0, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: 0), control: CGPoint(x: 0, y: 0))
        
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }
}
