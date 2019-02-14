//
//  LoginCoordinator.swift
//  Sepanta
//
//  Created by Iman on 11/25/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class LoginCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator : MainCoordinator?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        if let loginViewController = fromViewController as? LoginViewController {
            LoginFinished(loginViewController)
        }
        if let smsViewController = fromViewController as? SMSConfirmViewController {
            SMSVerificationFinished(smsViewController)
        }
    }
    
    func removeChild(_ aviewController : UIViewControllerWithCoordinator?){
        guard aviewController != nil else{
            return
        }
        if let aCoordinator = aviewController?.coordinator! {
            for (index,coordinator) in childCoordinators.enumerated() {
                if (coordinator === aCoordinator) {
                    childCoordinators.remove(at: index)
                    break
                }
            }
        }
    }
    
    func SMSVerificationFinished(_ smsViewController : SMSConfirmViewController?) {
        removeChild(smsViewController)
    }
    
    func LoginFinished(_ loginViewController : LoginViewController?){
        removeChild(loginViewController)
    }
    
    func start() {
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func gotoSMSVerification(Set mobileNumber : String) {
        let vc = SMSConfirmViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
        vc.mobileNumber = mobileNumber
    }
    
}
