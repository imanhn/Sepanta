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
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 20, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)

    }
}

class UnderLinedSelectableTextField: UITextField {
    override func draw(_ rect: CGRect) {
        let sizeOfTriangle = rect.height/4;
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 20, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        let contextTriangle = UIGraphicsGetCurrentContext()
        contextTriangle?.setLineWidth(2.0)
        contextTriangle?.setStrokeColor((UIColor( red: 0.2,     green: 0.2, blue:0.2, alpha: 1.0 )).cgColor)
        contextTriangle?.move(to: CGPoint(x: 20, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 20+sizeOfTriangle, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 20, y: self.bounds.height-5-sizeOfTriangle))
        contextTriangle?.closePath()
        contextTriangle?.fillPath()
    }
}
class MainButton:UIButton{
    override func draw(_ rect: CGRect) {
        var imageView : UIImageView
        let frame = self.superview?.superview?.convert(self.frame, from : self.superview)
        let x = frame?.origin.x
        let y = frame?.origin.y
        imageView  = UIImageView(frame:CGRect(x:x!, y:y!, width:self.bounds.width*1.6    , height:self.bounds.height*1.6));
        imageView.image = UIImage(imageLiteralResourceName: "btn_01")
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

class CircularButton: UIButton {
    var curvSize : CGFloat = 10;
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width-2, height: self.bounds.height-2)
        //let bezPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: self.bounds.width/2, height: self.bounds.height/2)).cgPath
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: insideCGRec.width/2, height: insideCGRec.height/2)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
}

class TriangularButton: UIButton {
    var curvSize : CGFloat = 20;
    var buttonLabel : String = "";
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let w = self.bounds.width
        let h = self.bounds.height
        let l = min(w,h)
        print("w : ",w,"  h : ",h, "  l : ",l)
        let sinus : CGFloat = sin(60.0 * 3.141592 / 180)
        let cosinus : CGFloat = cos(60.0 * 3.141592 / 180)
        
        context?.setLineWidth(5.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        
        context?.move(to: CGPoint(x: l/2, y: l))
        
        context?.addLine(to: CGPoint(x: l-curvSize, y: l))
        context?.addQuadCurve(to: CGPoint(x: l-(curvSize*cosinus), y: l-(curvSize*sinus)), control: CGPoint(x: l, y: l))

  
        context?.addLine(to: CGPoint(x: (l/2)+curvSize*cosinus, y: curvSize*sinus))
        context?.addQuadCurve(to: CGPoint(x: (l/2)-(curvSize*cosinus), y: (curvSize*sinus)), control: CGPoint(x: l/2, y: 0))

        context?.addLine(to: CGPoint(x: curvSize*cosinus, y: l-curvSize*sinus))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: l), control: CGPoint(x: 0, y: l))

            
        context?.closePath()
//        context?.setShadow(offset: CGSize(width: 4, height: 4), blur: 0.1)
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
