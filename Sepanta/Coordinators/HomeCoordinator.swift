//
//  HomePageController.swift
//  Sepanta
//
//  Created by Iman on 11/30/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator : Coordinator?
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
        if let homeViewController = fromViewController as? HomeViewController {
            HomeViewFinsihed(homeViewController)
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
    

    func HomeViewFinsihed(_ homeViewController : HomeViewController?) {
        removeChild(homeViewController)
    }

    func gotoSepantaieGroups (){
        let vc = SepantaGroupsViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
