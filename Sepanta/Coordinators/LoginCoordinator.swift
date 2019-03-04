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
    weak var parentCoordinator : AppCoordinator?
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
            removeChild(loginViewController.coordinator!)
        }
        if let smsViewController = fromViewController as? SMSConfirmViewController {
            removeChild(smsViewController.coordinator!)
        }
        if let signupViewController = fromViewController as? SignupViewController {
            removeChild(signupViewController.coordinator!)
        }

    }
    
    func removeChild(_ aCoordinator : Coordinator){
        
        for (index,coordinator) in childCoordinators.enumerated() {
            if (coordinator === aCoordinator) {
                childCoordinators.remove(at: index)
                print("     Remving ",aCoordinator)
                break
            }
        }
        
    }

    
    func start() {
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func gotoSMSVerification(Set mobileNumber : String) {
        let vc = SMSConfirmViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        vc.mobileNumber = mobileNumber
    }

    func gotoSignup() {
        let vc = SignupViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func gotoHomePage() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
    }
}
