//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

import UIKit


enum Gender : String {
    
    case male = "مرد",female = "زن"
    static var allLabels = ["زن","مرد"]
}

struct genders {
    var type : String = "جنسیت"//Gender.allLabels.first!
}

class SignupViewController: UIViewController  {

    var model = genders() {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    
    @IBOutlet weak var genderTextField: UnderLinedTextField!
    @IBAction func GenderTextTouchDown(_ sender: Any) {
       
        let controller = ArrayChoiceTableViewController(Gender.allLabels) {
            (type) in self.model.type = type
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 150)
        showPopup(controller, sourceView: sender as! UIView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.genderTextField.text = model.type
        //insertText(String(describing: model.type))
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


