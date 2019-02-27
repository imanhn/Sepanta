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
class AdImageView : UIImageView{
    
    func getCutPath() -> UIBezierPath{
        var MBB = self.layer.bounds
        let curvSize : CGFloat = 25;
        let smallCurvSize : CGFloat = 10;
        let sinus : CGFloat = sin(60.0 * 3.141592 / 180) //0.86
        let cosinus : CGFloat = cos(60.0 * 3.141592 / 180) // 0.5
        let tangent : CGFloat = tan(60.0 * 3.141592 / 180) // 1.732
        let leftMarginPorportion : CGFloat = 0.1
        MBB = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.bounds.height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: MBB.width, y: 0))
        
        path.addLine(to: CGPoint(x: MBB.width, y: MBB.height))
        path.addLine(to: CGPoint(x: (MBB.width * leftMarginPorportion)+curvSize, y: MBB.height))
        
        
        path.addQuadCurve(to: CGPoint(x: (MBB.width * leftMarginPorportion)+curvSize*cosinus, y: MBB.height-curvSize*sinus), controlPoint: CGPoint(x: (MBB.width * leftMarginPorportion), y: MBB.height))
        
        path.addLine(to: CGPoint(x: (MBB.width * leftMarginPorportion)+(MBB.height/tangent)-(smallCurvSize*cosinus), y: smallCurvSize*sinus))
        
        path.addQuadCurve(to: CGPoint(x: (MBB.width * leftMarginPorportion)+(MBB.height/tangent)+smallCurvSize, y: 0), controlPoint: CGPoint(x: (MBB.width * leftMarginPorportion)+(MBB.height/tangent), y: 0))
        path.close()
        return path
        
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        //print("Initing")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print("init required")
        self.cutImage()
        //self.contentMode = UIViewContentMode.scaleToFill
        
        //fatalError("init(coder:) has not been implemented")
    }
 
    func cutImage(){
        //print("Cutting...")
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = self.getCutPath().cgPath
        //print("Bounds W/H : ",self.bounds.width,"  ",self.bounds.height)
        //print("Frame W/H : ",self.frame.width,"  ",self.frame.height)
        
//        self.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.bounds.height)
 //       let path = CGPath(rect: self.bounds, transform: nil)
//        shapeLayer.path = path
        self.layer.mask = shapeLayer;
        self.layer.masksToBounds = false
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
        let bezPath = UIBezierPath(roundedRect: self.bounds.applying(downScaling), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
}


class CustomSearchBar: UITextField {
    var curvSize : CGFloat = 20;
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()

        let BB = CGRect(x: 4, y: 4, width: self.bounds.width-8, height: self.bounds.height-8)
        let boundPath = UIBezierPath(roundedRect: BB, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath

        let shadow1 = CGRect(x: 3, y: 3, width: self.bounds.width-6, height: self.bounds.height-6)
        let shadow1Path = UIBezierPath(roundedRect: shadow1, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        let shadow2 = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let shadow2Path = UIBezierPath(roundedRect: shadow2, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath

        context?.setLineWidth(3.0)
        context?.setStrokeColor((UIColor( red: 0.99,     green: 0.98, blue:0.99, alpha: 0.5 )).cgColor)
        context?.addPath(shadow2Path)
        context?.drawPath(using: CGPathDrawingMode.stroke)

        context?.setLineWidth(3.0)
        context?.setStrokeColor((UIColor( red: 0.968,     green: 0.968, blue:0.968, alpha: 0.5 )).cgColor)
        context?.addPath(shadow1Path)
        context?.drawPath(using: CGPathDrawingMode.stroke)

        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.9,     green: 0.9, blue:0.9, alpha: 0.5 )).cgColor)
        context?.addPath(boundPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)

    }
}
/*
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
        //print("w : ",w,"  h : ",h, "  l : ",l)
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
*/
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
class UIViewWithDash: UIView {
    /*
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 */
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1.0)
        //context?.setStrokeColor((UIColor( red: 0.99,     green: 0.98, blue:0.99, alpha: 1.0 )).cgColor)
        
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)

        context?.move(to: CGPoint(x: 0, y: self.bounds.height/2))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height/2))
        
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

extension UISearchBar {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
       // layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
