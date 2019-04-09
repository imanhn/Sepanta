//
//  EditProfileViewController.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxAlamofire

class EditProfileViewController : UIViewControllerWithErrorBar,Storyboarded {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet var topView: UIView!
    weak var coordinator : HomeCoordinator?
    var editProfileUI : EditProfileUI! = EditProfileUI()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator?.popOneLevel()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        editProfileUI.sendEditedData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileUI.showForm(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
