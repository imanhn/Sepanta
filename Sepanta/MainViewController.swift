//
//  mainViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    var slides : [UIImage] = [UIImage(named: "slide1")!,UIImage(named: "slide2")!,UIImage(named: "slide3")!,UIImage(named: "slide4")!]
    let blankImage = UIImage(named: "blank")
    @IBOutlet weak var settingButton: CircularButton!
    @IBOutlet weak var profileButton: CircularButton!
    @IBOutlet weak var newsButton: CircularButton!
    @IBOutlet weak var favoriteButton: CircularButton!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet var PageView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var poldarsho: MainButton!
    @IBOutlet weak var jadidtarinha: MainButton!
    @IBOutlet weak var nazdikeman: MainButton!
    @IBOutlet weak var sepantaie: MainButton!
    
    @IBOutlet var currentImageView: AdImageView!
    @IBOutlet weak var leftImageView: AdImageView!
    @IBOutlet weak var rightImageView: AdImageView!
    
    var adsPage = 1;
    var startLocation = CGPoint(x: 0, y: 0)
    var endLocation = CGPoint(x: 0, y: 0)
    var token : String?
    var userID : String?
    
    func setUserID(anID : String){
        self.userID = anID
    }
    
    func setToken(aToken : String){
        self.token = aToken
    }
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            startLocation = sender.location(in: self.view)
            //print("Start X : ",startLocation.x," Y : ",startLocation.y)
        } else if (sender.state == UIGestureRecognizerState.ended) {
            endLocation = sender.location(in: self.view)
            let animDurationInterval = TimeInterval(1/(abs(sender.velocity(in: self.view).x/1000)))
            //print("Velocity : ",sender.velocity(in: self.view))
            let deltaX = endLocation.x - startLocation.x
            if (deltaX > 100) && (adsPage > 0)  {
                //print("Sliding to left ",self.adsPage)
                UIView.animate(withDuration: animDurationInterval, animations: {
                    self.currentImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.currentImageView.layer.frame.origin.y, width: self.currentImageView.layer.bounds.width, height: self.currentImageView.layer.bounds.height)
                    self.leftImageView.layer.frame = CGRect(x: 0, y: self.leftImageView.layer.frame.origin.y, width: self.leftImageView.layer.bounds.width, height: self.leftImageView.layer.bounds.height)
                }) { _ in
                    self.adsPage = self.adsPage - 1
                    //Temporary make current the left image so when moving back the frames it would be felt by the user
                    self.currentImageView.image = self.leftImageView.image
                    //Moving back frames to their original location
                    self.currentImageView.layer.frame = CGRect(x: 0, y: self.currentImageView.layer.frame.origin.y, width: self.currentImageView.layer.bounds.width, height: self.currentImageView.layer.bounds.height)
                    self.leftImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.leftImageView.layer.frame.origin.y, width: self.leftImageView.layer.bounds.width, height: self.leftImageView.layer.bounds.height)
                    self.setupLeftAndRightImages()
                }

            } else if (deltaX < -100) && (adsPage < slides.count-1) {
                //print("Sliding to right ",self.adsPage)
                UIView.animate(withDuration: animDurationInterval, animations: {
                    self.currentImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.currentImageView.layer.frame.origin.y, width: self.currentImageView.layer.bounds.width, height: self.currentImageView.layer.bounds.height)
                    self.rightImageView.layer.frame = CGRect(x: 0, y: self.rightImageView.layer.frame.origin.y, width: self.rightImageView.layer.bounds.width, height: self.rightImageView.layer.bounds.height)
                }) { _ in
                    self.adsPage = self.adsPage + 1
                    //Temporary make current the right image so when moving back the frames it would be felt by the user
                    self.currentImageView.image = self.rightImageView.image
                    //Moving back frames to their original location
                    self.currentImageView.layer.frame = CGRect(x: 0, y: self.currentImageView.layer.frame.origin.y, width: self.currentImageView.layer.bounds.width, height: self.currentImageView.layer.bounds.height)
                    self.rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.rightImageView.layer.frame.origin.y, width: self.rightImageView.layer.bounds.width, height: self.rightImageView.layer.bounds.height)
                    self.setupLeftAndRightImages()
                }
            }else{
                // Moving Back to their locations
                //print("Rolling Back ",self.adsPage)
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentImageView.layer.frame = CGRect(x: 0, y: self.currentImageView.layer.frame.origin.y, width: self.currentImageView.layer.bounds.width, height: self.currentImageView.layer.bounds.height)
                    self.rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.rightImageView.layer.frame.origin.y, width: self.rightImageView.layer.bounds.width, height: self.rightImageView.layer.bounds.height)
                    self.leftImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.leftImageView.layer.frame.origin.y, width: self.leftImageView.layer.bounds.width, height: self.leftImageView.layer.bounds.height)
                }) { _ in
                }
            }
            //print("END X : ",endLocation.x," Y : ",endLocation.y)
        } else if (sender.state == UIGestureRecognizerState.changed) {
            let midLocation = sender.location(in: self.view)
            var deltaX = midLocation.x - startLocation.x
            if (deltaX < 0) && (adsPage == slides.count-1) ||  (deltaX > 0) && (adsPage == 0){
                   deltaX = deltaX / 4
            }
            //print("Moving Images ",self.adsPage," ",deltaX)
            self.currentImageView.layer.frame = CGRect(x: deltaX, y: self.currentImageView.layer.frame.origin.y, width: self.currentImageView.layer.bounds.width, height: self.currentImageView.layer.bounds.height)
            rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width + deltaX, y: rightImageView.layer.frame.origin.y, width: rightImageView.layer.bounds.width, height: rightImageView.layer.bounds.height)
            leftImageView.layer.frame = CGRect(x: deltaX - UIScreen.main.bounds.width, y: leftImageView.layer.frame.origin.y, width: leftImageView.layer.bounds.width, height: leftImageView.layer.bounds.height)
 
        }
    }
    
    func setupLeftAndRightImages(){
        if adsPage < 1 {
            //leftImageView.image = slides[adsPage] // No left! get the current for left
            leftImageView.image = slides.last // No left! get a blank logo for left
            rightImageView.image = slides[adsPage+1]
            currentImageView.image = slides[adsPage] // Current page
        } else if adsPage > slides.count-2 {
            leftImageView.image = slides[adsPage-1]
            rightImageView.image = slides.first // No right! get a blank logo for right
             currentImageView.image = slides[adsPage] // Current page
        } else {
            leftImageView.image = slides[adsPage-1]
            rightImageView.image = slides[adsPage+1]
             currentImageView.image = slides[adsPage] // Current page
        }
        currentImageView.image = slides[adsPage] // Current page
        currentImageView.setNeedsDisplay()
        //print("Page : ",adsPage)
        pageControl.currentPage = adsPage
        /*
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = currentImageView.bounds
        shapeLayer.path = currentImageView.getCutPath().cgPath
        currentImageView.layer.mask = shapeLayer;
        currentImageView.layer.masksToBounds = true;
        */
        
        /*
        print("ORI-Right : X: ",rightImageView.layer.frame.origin.x,"  Y: ",rightImageView.frame.origin.y,"  W: ", rightImageView.bounds.width," H: ", rightImageView.bounds.height)
        print("ORI-Left : X: ",leftImageView.layer.frame.origin.x,"  Y: ",leftImageView.frame.origin.y,"  W: ", leftImageView.bounds.width," H: ", leftImageView.bounds.height)
        print("ORI-Curn : X: ",currentImageView.layer.frame.origin.x,"  Y: ",currentImageView.frame.origin.y,"  W: ", currentImageView.bounds.width," H: ", currentImageView.bounds.height)
  */
    }

    
    override func viewDidLoad() {
       setupLeftAndRightImages()
        super.viewDidLoad()
        pageControl.numberOfPages = slides.count
       
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(pan)
        currentImageView.image = slides[adsPage] // Current page
        currentImageView.setNeedsDisplay()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


