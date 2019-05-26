//
//  SlideControl.swift
//  Sepanta
//
//  Created by Iman on 12/5/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SlideController {
    weak var delegate : HomeViewController!
    var slideTimer: Timer?
    var disposeList = [Disposable]()
    var adsPage = 1;
    var startLocation = CGPoint(x: 0, y: 0)
    var endLocation = CGPoint(x: 0, y: 0)
    var slides : [UIImage] = [UIImage(named: "logo_shape")!,UIImage(named: "logo_shape")!,UIImage(named: "logo_shape")!,UIImage(named: "logo_shape")!]
    var aPanStarted = false
    let myDisposeBag = DisposeBag()
    
    init(parentController : HomeViewController){
        self.delegate = parentController
        setupLeftAndRightImages()
        self.delegate.pageControl.numberOfPages = slides.count
        self.delegate.currentImageView.image = slides[adsPage] // Current page
        self.delegate.currentImageView.setNeedsDisplay()
        let slideObs = SlidesAndPaths.shared.slidesObs
            .filter({$0.count >= 3})
            .subscribe(onNext: { [unowned self] (innerSlides) in
                //print("Setting new Slides....")
                self.slides = innerSlides.map({$0.aUIImage})
                self.delegate.pageControl.numberOfPages = innerSlides.count
                //print("  slides : ",self.slides)
                self.setupLeftAndRightImages()
            }, onError: {_ in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
        slideObs.disposed(by: myDisposeBag)
        disposeList.append(slideObs)
        startTimer()
    }
    func startTimer(){
        if slideTimer == nil {
            slideTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateSlide), userInfo: nil, repeats: true)
        }
    }

    func endTimer() {
        if slideTimer != nil {
            slideTimer?.invalidate()
        }
    }
    
    @objc func updateSlide(){
        if self.adsPage == self.slides.count - 1 {
            self.adsPage = 0
        }else{
            self.adsPage = self.adsPage + 1
        }
        let animDurationInterval = 0.3
        UIView.animate(withDuration: animDurationInterval, animations: {
            self.delegate.currentImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
            self.delegate.rightImageView.layer.frame = CGRect(x: 0, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
        }) { _ in
            
            //Temporary make current the right image so when moving back the frames it would be felt by the user
            self.delegate.currentImageView.image = self.delegate.rightImageView.image
            //Moving back frames to their original location
            self.delegate.currentImageView.layer.frame = CGRect(x: 0, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
            self.delegate.rightImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
            self.setupLeftAndRightImages()
        }
    }
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        //print("Pan Status : ",aPanStarted," State : ",sender.state)
        let panStartLocation = sender.location(in: self.delegate.slideView)        
        if (sender.state == UIGestureRecognizerState.began && isOnSlideView(panStartLocation)) {
            //print("Pan STARTED")
            startLocation = sender.location(in: self.delegate.view)
            aPanStarted = true
            //print("Start X : ",startLocation.x," Y : ",startLocation.y)
        } else if (sender.state == UIGestureRecognizerState.ended && aPanStarted) {
            //print("Pan ENDED")
            endLocation = sender.location(in: self.delegate.view)
            aPanStarted = false
            let animDurationInterval = TimeInterval(1/(abs(sender.velocity(in: self.delegate.view).x/1000)))
            //print("Velocity : ",sender.velocity(in: self.delegate.view))
            let deltaX = endLocation.x - startLocation.x
            if (deltaX > 40) && (adsPage > 0)  {
                //print("Sliding to left ",self.adsPage)
                UIView.animate(withDuration: animDurationInterval, animations: {
                    self.delegate.currentImageView.layer.frame = CGRect(x: UIScreen.main.bounds.width, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.leftImageView.layer.frame = CGRect(x: 0, y: self.delegate.leftImageView.layer.frame.origin.y, width: self.delegate.leftImageView.layer.bounds.width, height: self.delegate.leftImageView.layer.bounds.height)
                }) { _ in
                    if self.adsPage < 1 {return}
                    self.adsPage = self.adsPage - 1
                    //Temporary make current the left image so when moving back the frames it would be felt by the user
                    self.delegate.currentImageView.image = self.delegate.leftImageView.image
                    //Moving back frames to their original location
                    self.delegate.currentImageView.layer.frame = CGRect(x: 0, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.leftImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.delegate.leftImageView.layer.frame.origin.y, width: self.delegate.leftImageView.layer.bounds.width, height: self.delegate.leftImageView.layer.bounds.height)
                    self.setupLeftAndRightImages()
                }
                
            } else if (deltaX < -40) && (adsPage < slides.count-1) {
                //print("Sliding to right ",self.adsPage)
                UIView.animate(withDuration: animDurationInterval, animations: {
                    self.delegate.currentImageView.layer.frame = CGRect(x: -1 * UIScreen.main.bounds.width, y: self.delegate.currentImageView.layer.frame.origin.y, width: self.delegate.currentImageView.layer.bounds.width, height: self.delegate.currentImageView.layer.bounds.height)
                    self.delegate.rightImageView.layer.frame = CGRect(x: 0, y: self.delegate.rightImageView.layer.frame.origin.y, width: self.delegate.rightImageView.layer.bounds.width, height: self.delegate.rightImageView.layer.bounds.height)
                }) { _ in
                    if self.adsPage > self.slides.count-2 {return}
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
        } else if (sender.state == UIGestureRecognizerState.changed && aPanStarted) {
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
            if adsPage+1 <= slides.count-1 {
                self.delegate.rightImageView.image = slides[adsPage+1]
            }
            self.delegate.currentImageView.image = slides[adsPage] // Current page
        } else if adsPage > slides.count-2 {
            if adsPage-1 >= 0 {
                self.delegate.leftImageView.image = slides[adsPage-1]
            }
            self.delegate.rightImageView.image = slides.first // No right! get a blank logo for right
            if adsPage <= slides.count-1 {
                self.delegate.currentImageView.image = slides[adsPage] // Current page
            }
            //adsPage = slides.count-2
        } else {
            if adsPage-1 >= 0 {
                self.delegate.leftImageView.image = slides[adsPage-1]
            }
            if adsPage+1 <= slides.count-1 {
                self.delegate.rightImageView.image = slides[adsPage+1]
            }
            if adsPage <= slides.count-1 {
                self.delegate.currentImageView.image = slides[adsPage] // Current page
            }
        }
        if adsPage <= slides.count-1 {
            self.delegate.currentImageView.image = slides[adsPage] // Current page
        }
        self.delegate.currentImageView.setNeedsDisplay()
        //print("Page : ",adsPage)
        self.delegate.pageControl.currentPage = adsPage
        if SlidesAndPaths.shared.slides.count > adsPage {
            self.delegate.commentLabel.text = SlidesAndPaths.shared.slides[adsPage].title
        }
    }
    func isOnSlideView(_ aLocation : CGPoint)->Bool{
        if aLocation.x > 0 && aLocation.x < self.delegate.slideView.frame.width &&
            aLocation.y > 0 && aLocation.y < self.delegate.slideView.frame.height{
            return true
        }
        return false
    }
    func handleTap(_ sender : UITapGestureRecognizer){
        if (sender.state == UIGestureRecognizerState.ended) {
            let tapLocation = sender.location(in: self.delegate.slideView)
            if isOnSlideView(tapLocation){
                let ashop = Shop(shop_id: SlidesAndPaths.shared.slides[adsPage].shop_id,
                                 user_id: SlidesAndPaths.shared.slides[adsPage].user_id,
                                 shop_name: "",
                                 shop_off: 0,
                                 lat: 0, long: 0,
                                 image: SlidesAndPaths.shared.slides[adsPage].images,
                                 rate: "",
                                 rate_count: 0,
                                 follower_count: 0, created_at: "")
                self.delegate.coordinator!.pushShop(Shop: ashop)
            }
        }

    }
}
