//
//  SlideControl.swift
//  Sepanta
//
//  Created by Iman on 12/5/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class SlideController {
    var delegate : HomeViewController
    var adsPage = 1;
    var startLocation = CGPoint(x: 0, y: 0)
    var endLocation = CGPoint(x: 0, y: 0)
    var slides : [UIImage] = [UIImage(named: "slide1")!,UIImage(named: "slide2")!,UIImage(named: "slide3")!,UIImage(named: "slide4")!]
    
    init(parentController : HomeViewController){
        self.delegate = parentController
    }
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            startLocation = sender.location(in: self.delegate.view)
            //print("Start X : ",startLocation.x," Y : ",startLocation.y)
        } else if (sender.state == UIGestureRecognizerState.ended) {
            endLocation = sender.location(in: self.delegate.view)
            let animDurationInterval = TimeInterval(1/(abs(sender.velocity(in: self.delegate.view).x/1000)))
            //print("Velocity : ",sender.velocity(in: self.delegate.view))
            let deltaX = endLocation.x - startLocation.x
            if (deltaX > 100) && (adsPage > 0)  {
                //print("Sliding to left ",self.adsPage)
                UIView.animate(withDuration: animDurationInterval, animations: {
                    self.delegate.currentImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.leftImageView.layer.frame = CGRect(x: 0, y: self.delegate.leftImageView.layer.frame.origin.y, width: self.delegate.leftImageView.layer.bounds.width, height: self.delegate.leftImageView.layer.bounds.height)
                }) { _ in
                    self.adsPage = self.adsPage - 1
                    //Temporary make current the left image so when moving back the frames it would be felt by the user
                    self.delegate.currentImageView.image = self.delegate.leftImageView.image
                    //Moving back frames to their original location
                    self.delegate.currentImageView.layer.frame = CGRect(x: 0, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.leftImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.delegate.leftImageView.layer.frame.origin.y, width: self.delegate.leftImageView.layer.bounds.width, height: self.delegate.leftImageView.layer.bounds.height)
                    self.setupLeftAndRightImages()
                }
                
            } else if (deltaX < -100) && (adsPage < slides.count-1) {
                //print("Sliding to right ",self.adsPage)
                UIView.animate(withDuration: animDurationInterval, animations: {
                    self.delegate.currentImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.rightImageView.layer.frame = CGRect(x: 0, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
                }) { _ in
                    self.adsPage = self.adsPage + 1
                    //Temporary make current the right image so when moving back the frames it would be felt by the user
                    self.delegate.currentImageView.image = self.delegate.rightImageView.image
                    //Moving back frames to their original location
                    self.delegate.currentImageView.layer.frame = CGRect(x: 0, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
                    self.setupLeftAndRightImages()
                }
            }else{
                // Moving Back to their locations
                //print("Rolling Back ",self.adsPage)
                UIView.animate(withDuration: 0.2, animations: {
                    self.delegate.currentImageView.layer.frame = CGRect(x: 0, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
                    self.delegate.leftImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.delegate.leftImageView.layer.frame.origin.y, width: self.delegate.leftImageView.layer.bounds.width, height: self.delegate.leftImageView.layer.bounds.height)
                }) { _ in
                }
            }
            //print("END X : ",endLocation.x," Y : ",endLocation.y)
        } else if (sender.state == UIGestureRecognizerState.changed) {
            let midLocation = sender.location(in: self.delegate.view)
            var deltaX = midLocation.x - startLocation.x
            if (deltaX < 0) && (adsPage == slides.count-1) ||  (deltaX > 0) && (adsPage == 0){
                deltaX = deltaX / 4
            }
            //print("Moving Images ",self.adsPage," ",deltaX)
            self.delegate.currentImageView.layer.frame = CGRect(x: deltaX, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
            self.delegate.rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width + deltaX, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
            self.delegate.leftImageView.layer.frame = CGRect(x: deltaX - UIScreen.main.bounds.width, y: self.delegate.leftImageView.layer.frame.origin.y, width: self.delegate.leftImageView.layer.bounds.width, height: self.delegate.leftImageView.layer.bounds.height)
            
        }
    }
    
    func setupLeftAndRightImages(){
        if adsPage < 1 {
            //leftImageView.image = slides[adsPage] // No left! get the current for left
            self.delegate.leftImageView.image = slides.last // No left! get a blank logo for left
            self.delegate.rightImageView.image = slides[adsPage+1]
            self.delegate.currentImageView.image = slides[adsPage] // Current page
        } else if adsPage > slides.count-2 {
            self.delegate.leftImageView.image = slides[adsPage-1]
            self.delegate.rightImageView.image = slides.first // No right! get a blank logo for right
            self.delegate.currentImageView.image = slides[adsPage] // Current page
        } else {
            self.delegate.leftImageView.image = slides[adsPage-1]
            self.delegate.rightImageView.image = slides[adsPage+1]
            self.delegate.currentImageView.image = slides[adsPage] // Current page
        }
        self.delegate.currentImageView.image = slides[adsPage] // Current page
        self.delegate.currentImageView.setNeedsDisplay()
        //print("Page : ",adsPage)
        self.delegate.pageControl.currentPage = adsPage
    }
}
