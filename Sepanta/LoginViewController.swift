//
//  ViewController.swift
//  Sepanta
//
//  Created by Iman on 11/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var PageView: UIView!
    @IBOutlet weak var LoginPanelView: TabbedView!
    @IBOutlet weak var SignupButton: TabbedButton!
    @IBOutlet weak var EnterButton: UIButton!
    func initCurves() {
//        let maskView = UIView(frame: CGRect(x: 0, y: 0, width: LoginPanelView.bounds.width/2, height: LoginPanelView.bounds.height/3))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCurves()
        // Do any additional setup after loading the view, tßypically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

