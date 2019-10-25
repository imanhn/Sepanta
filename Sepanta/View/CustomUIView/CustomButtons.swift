//
//  CustomButtons.swift
//  Sepanta
//
//  Created by Iman on 8/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

class FilterButton: UIButton {
    var curvSize: CGFloat = 5
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.backgroundColor = UIColor.white
                    //self.alpha = 1.0
                } else {
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
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: frame.height/2, bottom: 0, right: 0)
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class SubmitButton: UIButton {
    var curvSize: CGFloat = 5
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.backgroundColor = UIColor(hex: 0x515152)
                    //self.alpha = 1.0
                } else {
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
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: frame.height/2, bottom: 0, right: 0)
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class SubmitButtonOnRedBar: UIButton {
    var curvSize: CGFloat = 5
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.setTitleColor(UIColor(hex: 0x515152), for: .disabled)
                    self.setTitleColor(UIColor(hex: 0x515152), for: .application)
                    self.setTitleColor(UIColor(hex: 0x515152), for: .normal)
                    //self.alpha = 1.0
                } else {
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
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: frame.height/2, bottom: 0, right: 0)
        self.layer.cornerRadius = curvSize
        self.layer.masksToBounds = true
        let context = UIGraphicsGetCurrentContext()
        
        let insideCGRec: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
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
                        self.setImage(UIImage(named: "icon_tick_white"), for: .normal)
                    } else {
                        self.setImage(UIImage(named: "icon_add_white"), for: .normal)
                        self.backgroundColor = UIColor(hex: 0x9FDA64)
                    }
                    //self.alpha = 1.0
                } else {
                    self.backgroundColor = UIColor(hex: 0xD6D7D9)
                    //self.alpha = 0.5
                }
            }
        }
    }
}
class RoundedButton: UIButton {
    var curvSize: CGFloat = 5
    override var isEnabled: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isEnabled {
                    self.backgroundColor = UIColor(hex: 0x515152)
                    //self.alpha = 1.0
                } else {
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
        
        let insideCGRec: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
}

class RoundedButtonWithShadow: RoundedButton {
    override init(frame: CGRect) {
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
    var curvSize: CGFloat = 5
    var targetAction : (() -> Void) = {}
    @objc func runTargetAction() {
        targetAction()
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.layer.cornerRadius = curvSize
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: 0xD6D7D9).cgColor
        
        let insideCGRec: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let bezPath = UIBezierPath(roundedRect: insideCGRec, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: curvSize, height: curvSize)).cgPath
        
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor(hex: 0xD6D7D9)).cgColor)
        context?.setFillColor(UIColor(hex: 0x515152).cgColor)
        
        context?.addPath(bezPath)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}

class MainButton: UIButton {
    override func draw(_ rect: CGRect) {
        var imageView: UIImageView
        let frame = self.superview?.superview?.convert(self.frame, from: self.superview)
        let x = frame?.origin.x
        let y = frame?.origin.y
        imageView  = UIImageView(frame: CGRect(x: x!, y: y!, width: self.bounds.width*1.6, height: self.bounds.height*1.6))
        imageView.image = UIImage(imageLiteralResourceName: "btn_01")
    }
    
}
class TabbedButton: UIButton {
    var curvSize: CGFloat = 5
    var shiftUp: CGFloat = 10
    override func draw(_ rect: CGRect) {
        shiftUp = rect.height/6
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor((UIColor( red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0 )).cgColor)
        context?.setFillColor((UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )).cgColor)
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

class UIButtonWithBadge: UIButton {
    
    
    func animateView( _ view: UIView) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))
        view.layer.add(shakeAnimation, forKey: "position")
    }
    
    func createBadge(Number anum: Int, Size size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        var numStr = "E"
        if (anum <= 9) {
            numStr = "\(anum)".toPersianNumbers()
        } else
            if (anum > 2000) { numStr = "+2K"} else
                if (anum > 1000) { numStr = "+1K"} else {
                    numStr = "۹+"
        }
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let emptyBadge = UIImage(named: "badge")
        emptyBadge?.draw(in: areaSize)
        let textBox = CGRect(x: size.width/4, y: size.height/4, width: size.width/2, height: size.height/2)
        let lab = UILabel(frame: textBox)
        lab.text = numStr
        lab.font = UIFont (name: "Shabnam FD", size: 20)!
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        
        lab.adjustsFontSizeToFitWidth = true
        lab.drawText(in: textBox)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func addBadge(_ no: Int) {
        let buttonDim = self.frame.width
        let badgeDim: CGFloat = UIScreen.main.bounds.width/10 //buttonDim*0.75
        let offsetX = (buttonDim - badgeDim)/2
        let offsetY = -badgeDim/2
        let badgeFrame = CGRect(x: offsetX, y: offsetY, width: badgeDim, height: badgeDim)
        let badgeImageView = UIImageView(frame: badgeFrame)
        badgeImageView.layer.shadowColor = UIColor.black.cgColor
        badgeImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
        badgeImageView.layer.shadowRadius = 2
        badgeImageView.layer.opacity = 0.9
        badgeImageView.layer.shadowOpacity = 0.3
        badgeImageView.image = self.createBadge(Number: no, Size: badgeFrame.size)
        badgeImageView.tag = 123
        //if self.superview == nil {fatalError("super view is unset for butoon with badge")}
        self.addSubview(badgeImageView)
        animateView(badgeImageView)
    }
    
    func removeBadge() {
        self.subviews.forEach({if $0.tag == 123 {$0.removeFromSuperview()} })
    }
    
    func manageBadge(_ no: Int) {
        if no == 0 {
            self.removeBadge()
        } else {
            self.addBadge(no)
        }
    }
}
