//
//  HomeViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewControllerWithCoordinator,Storyboarded {

    var slideControl : SlideController?
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var currentImageView: AdImageView!
    @IBOutlet weak var leftImageView: AdImageView!
    @IBOutlet weak var rightImageView: AdImageView!


    @IBOutlet weak var searchTextField: CustomSearchBar!
    
    @IBAction func menuClicked(_ sender: Any) {
        guard let acoordinator = coordinator as? HomeCoordinator else {
            return
        }
        acoordinator.popMenu(self)
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
    
    override func viewDidLoad() {
        slideControl = SlideController(parentController: self)
        super.viewDidLoad()
        
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
        guard let acoordinator = coordinator as? HomeCoordinator else {
            return
        }
        acoordinator.gotoSepantaieGroups()
    }
    
}


