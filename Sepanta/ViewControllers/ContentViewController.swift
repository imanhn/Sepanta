//
//  ContentViewController.swift
//  Sepanta
//
//  Created by Iman on 2/21/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import UIKit

enum PageType {
    case Start
    case End
    case Series
}

class ContentViewController: UIViewController {
    weak var coordinator : HomeCoordinator?
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var helpTextView: UIView!
    @IBOutlet weak var labelViewToTopCons: NSLayoutConstraint!
    
    var titleString = ""
    var pageNo : Int = 0
    var pageType = PageType.Series
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpTextView.layer.shadowColor = UIColor.black.cgColor
        helpTextView.layer.shadowOffset = CGSize(width: 5, height: 5)
        helpTextView.layer.shadowRadius = 10
        helpTextView.layer.opacity = 0.9
        helpTextView.layer.shadowOpacity = 0.3
        if pageNo == 3 {
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
                self.labelViewToTopCons.constant = self.view.frame.height/2
            }
        }

        self.titleLabel.text = titleString
        slideImageView.image = UIImage(named: "P\(pageNo+1)")
        if pageType == PageType.End {doneButton.isHidden = false}else{doneButton.isHidden = true}
    }
    

}
