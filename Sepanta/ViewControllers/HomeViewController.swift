//
//  HomeViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewControllerWithErrorBar,Storyboarded {
    weak var coordinator : HomeCoordinator?
    var slideControl : SlideController?
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var currentImageView: AdImageView!
    @IBOutlet weak var leftImageView: AdImageView!
    @IBOutlet weak var rightImageView: AdImageView!


    @IBOutlet weak var searchTextField: CustomSearchBar!
    
    @IBAction func gotoProfile(_ sender: Any) {
        self.coordinator!.pushShowProfile()
        //self.coordinator!.logout()
    }
    @IBAction func gotoNewShops(_ sender: Any) {
        self.coordinator!.pushNewShops()
    }
    @IBAction func menuClicked(_ sender: Any) {
        (self.coordinator as! HomeCoordinator).openButtomMenu()
    }

    @IBAction func searchOnKeyboardPressed(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
        
    }

    //Passes events to delegate class
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        if slideControl != nil {
            slideControl?.handlePan(sender)
        }
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        SlidesAndPaths.shared.getHomeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideControl = SlideController(parentController: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //TEST
        //NetworkManager.shared.status.accept(CallStatus.error)
        //alert(Message:"آزمايش نوار اطلاعات")
        //Handle Tap to End Editing
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
       // Handles Slide Events and delivers them to self.handle_pan
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sepantaieClicked(_ sender: Any) {
        self.coordinator!.pushSepantaieGroup()
    }
    
    @IBAction func poldarshoClicked(_ sender: Any) {
        print("HomeViewController.Coordinator : ",coordinator)
        self.coordinator!.pushGetRich()
        
    }
    
}


