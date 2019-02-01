//
//  CustomWidgets.swift
//  Sepanta
//
//  Created by Iman on 11/12/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class TabbedButton: UIButton {
    var curvSize : CGFloat = 10;
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let downScaling : CGAffineTransform = CGAffineTransform(scaleX: 0.95, y: 0.9);
        let bezPath = UIBezierPath(roundedRect: self.bounds.applying(downScaling), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
}

class TabbedView: UIView {
    var curvSize : CGFloat = 10;
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        
        context?.move(to: CGPoint(x: curvSize, y: self.bounds.height/5))
        /* // Curv at the middle of buttons-Tab page foot!
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-curvSize, y: self.bounds.height/5))
        context?.addQuadCurve(to: CGPoint(x: (self.bounds.width/2), y: (self.bounds.height/5)-curvSize), control: CGPoint(x: (self.bounds.width/2), y: self.bounds.height/5))
        */
        context?.addLine(to: CGPoint(x: (self.bounds.width/2), y: self.bounds.height/5))
        
        context?.addLine(to: CGPoint(x: self.bounds.width/2, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width/2+curvSize, y: 0), control: CGPoint(x: (self.bounds.width/2), y: 0))
        
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-2*curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-2*curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 2*curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-2*curvSize), control: CGPoint(x: 0, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 0, y: self.bounds.height/5+curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: self.bounds.height/5), control: CGPoint(x: 0, y: self.bounds.height/5))
        
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }
}
