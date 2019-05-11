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

class FilterButton: UIButton {
    var curvSize : CGFloat = 5;
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.backgroundColor = UIColor.white
                    //self.alpha = 1.0
                }
                else {
                    self.backgroundColor = UIColor.white
                    //self.alpha = 0.5
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isEnabled = false
        self.contentMode = .scaleAspectFit
        self.semanticContentAttribute = .forceRightToLeft
        self.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        self.setTitleColor(UIColor(hex: 0x515152), for: .disabled)
        self.setImage(UIImage(named: "icon_tick_black"), for: .normal)
        self.setImage(UIImage(named: "icon_tick_black"), for: .disabled)
        //self.setImage(UIImage(named: "icon_tick_black"), for: .disabled)
        self.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, frame.height/2, 0, 0)
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class SubmitButton: UIButton {
    var curvSize : CGFloat = 5;
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.backgroundColor = UIColor(hex: 0x515152)
                    //self.alpha = 1.0
                }
                else {
                    self.backgroundColor = UIColor(hex: 0xD6D7D9)
                    //self.alpha = 0.5
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isEnabled = false
        self.contentMode = .scaleAspectFit
        self.semanticContentAttribute = .forceRightToLeft
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .disabled)
        self.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        self.setImage(UIImage(named: "icon_tick_white"), for: .disabled)
        //self.setImage(UIImage(named: "icon_tick_black"), for: .disabled)
        self.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, frame.height/2, 0, 0)
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class SubmitButtonOnRedBar: UIButton {
    var curvSize : CGFloat = 5;
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.setTitleColor(UIColor(hex: 0x515152), for: .disabled)
                    self.setTitleColor(UIColor(hex: 0x515152), for: .application)
                    self.setTitleColor(UIColor(hex: 0x515152), for: .normal)
                    //self.alpha = 1.0
                }
                else {
                    self.setTitleColor(UIColor(hex: 0xD6D7D9), for: .disabled)
                    self.setTitleColor(UIColor(hex: 0xD6D7D9), for: .application)
                    self.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)

                    //self.alpha = 0.5
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isEnabled = false
        self.contentMode = .scaleAspectFit
        self.semanticContentAttribute = .forceRightToLeft
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.darkGray, for: .disabled)
        self.backgroundColor = UIColor(hex: 0xFFFFFF)
        self.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        self.setImage(UIImage(named: "icon_tick_white"), for: .disabled)
        //self.setImage(UIImage(named: "icon_tick_black"), for: .disabled)
        self.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, frame.height/2, 0, 0)
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class FollowButton: SubmitButton {    
    var isFollowed = false
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    if self.isFollowed {
                        self.backgroundColor = UIColor(hex: 0x515152)
                    }else{
                        self.backgroundColor = UIColor(hex: 0x9FDA64)
                    }
                    //self.alpha = 1.0
                }
                else {
                    self.backgroundColor = UIColor(hex: 0xD6D7D9)
                    //self.alpha = 0.5
                }
            }
        }
    }
}
class RoundedButton: UIButton {
    var curvSize : CGFloat = 5;
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.backgroundColor = UIColor(hex: 0x515152)
                    //self.alpha = 1.0
                }
                else {
                    self.backgroundColor = UIColor.white
                    //self.alpha = 0.5
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        self.setTitleColor(UIColor(hex: 0xD6D7D9), for: .disabled)
        
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec : CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class RoundedButtonWithShadow : RoundedButton{
    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 2
        self.layer.opacity = 0.9
        self.layer.shadowOpacity = 0.3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
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

class UnderLinedSelectableTextFieldWithWhiteTri: UITextField {
    override func draw(_ rect: CGRect) {
        let sizeOfTriangle = rect.height/4;
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0x515152)).cgColor)
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
    var curvSize : CGFloat = 5;
    var shiftUp : CGFloat = 10
    override func draw(_ rect: CGRect) {
        shiftUp = rect.height/6
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.setFillColor((UIColor( red: 1.0,     green: 1.0, blue:1.0, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: curvSize, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-shiftUp-curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-curvSize, y: self.bounds.height-shiftUp), control: CGPoint(x: self.bounds.width, y: self.bounds.height-shiftUp))
        
        context?.addLine(to: CGPoint(x: curvSize, y: self.bounds.height-shiftUp))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-shiftUp-curvSize), control: CGPoint(x: 0, y: self.bounds.height-shiftUp))
        
        context?.addLine(to: CGPoint(x: 0, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: 0), control: CGPoint(x: 0, y: 0))
        
        context?.closePath()
        //context?.drawPath(using: CGPathDrawingMode.stroke)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        /*
        let context = UIGraphicsGetCurrentContext()
        let downScaling : CGAffineTransform = CGAffineTransform(scaleX: 1, y: 0.9);
        let bezPath = UIBezierPath(roundedRect: self.bounds.applying(downScaling), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        */
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
        //let tabbedButtonHeight :CGFloat = self.bounds.width / heightRatio
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84,     green: 0.84, blue:0.84, alpha: 1.0 )).cgColor)
        context?.setFillColor((UIColor( red: 1.0,     green: 1.0, blue:1.0, alpha: 1.0 )).cgColor)
        context?.move(to: CGPoint(x: curvSize, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width-curvSize, y: 0))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width, y: curvSize), control: CGPoint(x: self.bounds.width, y: 0))
        
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height-curvSize))
        context?.addQuadCurve(to: CGPoint(x: self.bounds.width-curvSize, y: self.bounds.height), control: CGPoint(x: self.bounds.width, y: self.bounds.height))

        context?.addLine(to: CGPoint(x: curvSize, y: self.bounds.height))
        context?.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.height-curvSize), control: CGPoint(x: 0, y: self.bounds.height))

        context?.addLine(to: CGPoint(x: 0, y: curvSize))
        context?.addQuadCurve(to: CGPoint(x: curvSize, y: 0), control: CGPoint(x: 0, y: 0))

        context?.closePath()
        //context?.drawPath(using: CGPathDrawingMode.stroke)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
    }
}
enum TabViewJustification {
    case Right
    case Left
}

class TabbedViewWithWhitePanel : UIView{
    var tabJust = TabViewJustification.Right
    var curvSize : CGFloat = 5;
    let movRight : CGFloat = 5;
    let movLeft : CGFloat = 5;
    let heightRatio :CGFloat = 6
    
    func getHeight()-> CGFloat {
        return self.bounds.width / self.heightRatio
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let tabbedButtonHeight :CGFloat = self.bounds.width / heightRatio
        
        if tabJust == TabViewJustification.Right {
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
        } else {
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

        }
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
protocol UITextFieldDelegateWithBackward : class{
    func deletePressed(_ sender : Any)
}

class CreditCardPartNumber : UITextField{
    weak var backwardDelegate : UITextFieldDelegateWithBackward?
    override func deleteBackward() {
        backwardDelegate?.deletePressed(self)
        super.deleteBackward()
        
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

class UIButtonWithBadge : UIButton {
    
    
    func animateView( _ view : UIView){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x - 5, y:view.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x + 5, y:view.center.y))
        view.layer.add(shakeAnimation, forKey: "position")
    }
    
    func createBadge(Number anum : Int,Size size : CGSize)->UIImage{
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        var numStr = "E"
        if anum <= 9 { numStr = "\(anum)".toPersianNumbers() } else {numStr = "۹+"}
        let emptyBadge = UIImage(named: "badge")
        emptyBadge?.draw(in: areaSize)
        let textBox = CGRect(x: size.width/4 , y: size.height/4, width: size.width/2, height: size.height/2)
        let lab = UILabel(frame: textBox)
        lab.text = numStr
        lab.font = UIFont (name: "Shabnam FD", size: 20)!
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        
        lab.adjustsFontSizeToFitWidth = true
        lab.drawText(in: textBox)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func addBadge(_ no : Int){
        let buttonDim = self.frame.width
        let badgeDim : CGFloat = UIScreen.main.bounds.width/10 //buttonDim*0.75
        let offsetX = (buttonDim - badgeDim)/2
        let offsetY = -badgeDim/2
        let badgeFrame = CGRect(x: offsetX, y: offsetY, width: badgeDim, height: badgeDim)
        let badgeImageView = UIImageView(frame: badgeFrame)
        badgeImageView.layer.shadowColor = UIColor.black.cgColor
        badgeImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
        badgeImageView.layer.shadowRadius = 2
        badgeImageView.layer.opacity = 0.9
        badgeImageView.layer.shadowOpacity = 0.3
        badgeImageView.image = self.createBadge(Number: no,Size: badgeFrame.size)
        badgeImageView.tag = 123
        //if self.superview == nil {fatalError("super view is unset for butoon with badge")}
        self.addSubview(badgeImageView)
        animateView(badgeImageView)
    }
    
    func removeBadge(){
        self.subviews.forEach({if $0.tag == 123 {$0.removeFromSuperview()} })
    }
    
    func manageBadge(_ no : Int){
        if no == 0 {
            self.removeBadge()
        } else {
            self.addBadge(no)
        }
    }
}


extension CGRect {
    func buildARowView(Image anImageName : String,Selectable selectable:Bool,PlaceHolderText aPlaceHolder : String)->(UIView,UITextField){
        let aView = UIView(frame: self)
        let lineView = UIView(frame: CGRect(x: 0, y: self.height-1, width: self.width, height: 1))
        lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
        aView.addSubview(lineView)
        
        aView.backgroundColor = UIColor.white
        let icondim = self.height / 3
        let spaceIconText : CGFloat = 20
        if anImageName.count > 0 {
            let imageRect = CGRect(x: (self.width-icondim), y: (self.height - icondim)/2, width: icondim, height: icondim)
            let anIcon = UIImageView(frame: imageRect)
            anIcon.image = UIImage(named: anImageName)
            anIcon.contentMode = .scaleAspectFit
            aView.addSubview(anIcon)
        }
        
        let aText = EmptyTextField(frame: CGRect(x: 0, y: 0, width: (self.width-icondim-spaceIconText), height: self.height))
        aText.font = UIFont(name: "Shabnam-FD", size: 14)
        aText.attributedPlaceholder = NSAttributedString(string: aPlaceHolder , attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0xD6D7D9)])
        aText.textAlignment = .right
        if selectable {
            let triangleImage = UIImageView(frame: CGRect(x: 0, y: self.height*3/4 - 5, width: self.height/4, height: self.height/4))
            triangleImage.image = UIImage(named: "icon_dropdown_red")
            aView.addSubview(triangleImage)
            aText.tag = 11
        }
        aView.addSubview(aText)        
        return (aView,aText)
    }
    
    func buildALabelView(Image anImageName : String,LabelText aStr : String,Lines noLines : Int)->(UIView,UILabel){
        let rect = self
        let aView = UIView(frame: rect)
        /*let lineView = UIView(frame: CGRect(x: 0, y: rect.height-1, width: rect.width, height: 1))
         lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
         aView.addSubview(lineView)
         */
        aView.backgroundColor = UIColor.white
        let icondim = rect.height / 3
        let spaceIconText : CGFloat = 20
        let imageRect = CGRect(x: (rect.width-icondim), y: (rect.height - icondim)/2, width: icondim, height: icondim)
        let anIcon = UIImageView(frame: imageRect)
        anIcon.image = UIImage(named: anImageName)
        anIcon.contentMode = .scaleAspectFit
        let aText = UILabel(frame: CGRect(x: 0, y: 0, width: (rect.width-icondim-spaceIconText), height: rect.height))
        
        if noLines == 3 {
            aText.font = UIFont(name: "Shabnam-FD", size: 12)
        }else if noLines == 2 {
            aText.font = UIFont(name: "Shabnam-FD", size: 12)
        }else if noLines == 1 {
            aText.font = UIFont(name: "Shabnam-FD", size: 14)
        }
        aText.adjustsFontSizeToFitWidth = true
        aText.textColor = UIColor(hex: 0x515152)
        aText.textAlignment = .right
        aText.text = aStr
        aText.numberOfLines = noLines
        
        //aText.delegate = self
        aView.addSubview(aText)
        aView.addSubview(anIcon)
        
        return (aView,aText)
    }
}

extension UIImageView {
    func animateView(){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 5, y:self.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 5, y:self.center.y))
        self.layer.add(shakeAnimation, forKey: "position")
    }
}
