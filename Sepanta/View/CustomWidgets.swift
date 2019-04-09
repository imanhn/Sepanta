//
//  CustomWidgets.swift
//  Sepanta
//
//  Created by Iman on 11/12/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class UnderLinedSelectableUIView: UIView {
    override func draw(_ rect: CGRect) {
        let sizeOfTriangle = rect.height/4;
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 0, y: self.bounds.height))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        let contextTriangle = UIGraphicsGetCurrentContext()
        contextTriangle?.setLineWidth(2.0)
        contextTriangle?.setStrokeColor((UIColor( red: 0.2,     green: 0.2, blue:0.2, alpha: 1.0 )).cgColor)
        contextTriangle?.move(to: CGPoint(x: 0, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: sizeOfTriangle, y: self.bounds.height-5))
        contextTriangle?.addLine(to: CGPoint(x: 0, y: self.bounds.height-5-sizeOfTriangle))
        contextTriangle?.closePath()
        contextTriangle?.fillPath()
    }
}

class RoundedButton: UIButton {
    var curvSize : CGFloat = 5;
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
}

class RoundedButtonWithDarkBackground: UIButton {
    var curvSize : CGFloat = 5;

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.layer.cornerRadius = curvSize
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: 0xD6D7D9).cgColor
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.setFillColor(UIColor(hex: 0x515152).cgColor)
        
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}

class EmptyTextField: UITextField {
    override func draw(_ rect: CGRect) {
    }
}

class UnderLinedTextField: UITextField {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 0, y: self.bounds.height))
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
        self.cutImage()
    }
 
    func cutImage(){
        //print("Cutting...")
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = self.getCutPath().cgPath
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


class RightTabbedView: UIView {
    var curvSize : CGFloat = 5;
    let movRight : CGFloat = 5;
    let heightRatio :CGFloat = 6
    
    func getHeight()-> CGFloat {
        return self.bounds.width / self.heightRatio
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let tabbedButtonHeight :CGFloat = self.bounds.width / 6
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        
        context?.move(to: CGPoint(x: curvSize, y: tabbedButtonHeight))

        context?.addLine(to: CGPoint(x: (self.bounds.width/2)+movRight, y: tabbedButtonHeight))
        
        context?.addLine(to: CGPoint(x: movRight+self.bounds.width/2, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: movRight+self.bounds.width/2+curvSize, y: 0), control: CGPoint(x: (movRight+self.bounds.width/2), y: 0))
        
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-2*curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-2*curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 2*curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-2*curvSize), control: CGPoint(x: 0, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 0, y: tabbedButtonHeight+curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: tabbedButtonHeight), control: CGPoint(x: 0, y: tabbedButtonHeight))
        
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }
}

class RoundedUIViewWithWhitePanel: UIView {
    var curvSize : CGFloat = 5;
    let movRight : CGFloat = 5;
    let heightRatio :CGFloat = 6
    
    func getHeight()-> CGFloat {
        return self.bounds.width / self.heightRatio
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let tabbedButtonHeight :CGFloat = self.bounds.width / heightRatio
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.setFillColor((UIColor( red: 1.0,     green: 1.0, blue:1.0, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: curvSize, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))

        context?.addLine(to: CGPoint(x: curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-curvSize), control: CGPoint(x: 0, y: self.bounds.height-curvSize))

        context?.addLine(to: CGPoint(x: 0, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: 0), control: CGPoint(x: 0, y: 0))

        context?.closePath()
        //context?.drawPath(using: CGPathDrawingMode.stroke)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
    }
}
class RightTabbedViewWithWhitePanel: UIView {
    var curvSize : CGFloat = 5;
    let movRight : CGFloat = 5;
    let heightRatio :CGFloat = 6
    
    func getHeight()-> CGFloat {
        return self.bounds.width / self.heightRatio
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let tabbedButtonHeight :CGFloat = self.bounds.width / heightRatio

        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.setFillColor((UIColor( red: 1.0,     green: 1.0, blue:1.0, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: curvSize, y: tabbedButtonHeight))

        context?.addLine(to: CGPoint(x: (self.bounds.width/2)+movRight, y: tabbedButtonHeight))
        
        context?.addLine(to: CGPoint(x: movRight+self.bounds.width/2, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: movRight+self.bounds.width/2+curvSize, y: 0), control: CGPoint(x: (movRight+self.bounds.width/2), y: 0))
        
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-2*curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-2*curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 2*curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-2*curvSize), control: CGPoint(x: 0, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 0, y: tabbedButtonHeight+curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: tabbedButtonHeight), control: CGPoint(x: 0, y: tabbedButtonHeight))
        
        context?.closePath()
        //context?.drawPath(using: CGPathDrawingMode.stroke)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
    }
}

// is being used in A Group - Shops View which is the header of a UITableView
class UIViewWithDash: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: 0, y: self.bounds.height/2))
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height/2))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }

}

class LeftTabbedView: UIView {
    var curvSize : CGFloat = 5;
    let movLeft : CGFloat = 5;
//    let viewToButtonRatio : CGFloat = 6.6667
    let heightRatio :CGFloat = 6
    
    func getHeight()-> CGFloat {
        return self.bounds.width / self.heightRatio
    }

    override func draw(_ rect: CGRect) {
        let tabbedButtonHeight :CGFloat = self.bounds.width / heightRatio
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        
        context?.move(to: CGPoint(x: curvSize, y: 0))
        
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-curvSize-movLeft, y: 0))
        context?.addQuadCurve(to: CGPoint(x: (self.bounds.width/2)-movLeft, y: curvSize), control: CGPoint(x: (self.bounds.width/2)-movLeft, y: 0))

        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-movLeft, y: tabbedButtonHeight - curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width/2+curvSize-movLeft, y: tabbedButtonHeight), control: CGPoint(x: (self.bounds.width/2)-movLeft, y: tabbedButtonHeight))

        context?.addLine(to: CGPoint(x: (self.bounds.width)-curvSize, y: tabbedButtonHeight))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: tabbedButtonHeight+curvSize), control: CGPoint(x: self.bounds.width, y: tabbedButtonHeight))

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

class LeftTabbedViewWithWhitePanel: UIView {
    var curvSize : CGFloat = 5;
    let movLeft : CGFloat = 5;
    let viewToButtonRatio : CGFloat = 5;
    let heightRatio :CGFloat = 6
    
    func getHeight()-> CGFloat {
        return self.bounds.width / self.heightRatio
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()//UIGraphicsBeginImageContext(self.bounds.size)//
        let tabbedButtonHeight :CGFloat = self.bounds.width / heightRatio
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.setFillColor((UIColor( red: 1.0,     green: 1.0, blue:1.0, alpha: 1.0 )).cgColor)

        context?.move(to: CGPoint(x: curvSize, y: 0))
        
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-curvSize-movLeft, y: 0))
        context?.addQuadCurve(to: CGPoint(x: (self.bounds.width/2)-movLeft, y: curvSize), control: CGPoint(x: (self.bounds.width/2)-movLeft, y: 0))
        
        context?.addLine(to: CGPoint(x: (self.bounds.width/2)-movLeft, y: tabbedButtonHeight - curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width/2+curvSize-movLeft, y: tabbedButtonHeight), control: CGPoint(x: (self.bounds.width/2)-movLeft, y: tabbedButtonHeight))
        
        context?.addLine(to: CGPoint(x: (self.bounds.width)-curvSize, y: tabbedButtonHeight))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: tabbedButtonHeight+curvSize), control: CGPoint(x: self.bounds.width, y: tabbedButtonHeight))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-2*curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-2*curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 2*curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-2*curvSize), control: CGPoint(x: 0, y: self.bounds.height))
        
        context?.addLine(to: CGPoint(x: 0, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: 0), control: CGPoint(x: 0, y: 0))
        
        context?.closePath()

        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
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
