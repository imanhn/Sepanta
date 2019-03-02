//
//  GroupsController.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class GroupsCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator : HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("GroupsCoordinator : didShow ",viewController)
        print("All ViewControllers in NavigationViewController : ",navigationController.viewControllers)
        print(" Transition : ",navigationController.transitionCoordinator)
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            print("NO FROM!")
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            print("GroupCoord : from view : " ,fromViewController)
            return
        }
        if let homeViewController = fromViewController as? HomeViewController {
            print("GroupCoordinator : Removing HomeViewCoordinator")
            HomeViewFinsihed(homeViewController)
        }
        if let sepantaGroupsViewController = fromViewController as? SepantaGroupsViewController {
            print("GroupCoordinator : Removing Sepanta Coordinator..")
            SepantaGroupsViewFinsihed(sepantaGroupsViewController)
        }

    }
    
    func HomeViewFinsihed(_ homeViewController : HomeViewController?) {
        removeChild(homeViewController)
    }
    
    func SepantaGroupsViewFinsihed(_ sepantaGroupsViewController : SepantaGroupsViewController?) {
        removeChild(sepantaGroupsViewController)
    }
    
    func removeChild(_ aviewController : UIViewControllerWithCoordinator?){
        guard aviewController != nil else{
            return
        }
        if let aCoordinator = aviewController?.coordinator! {
            for (index,coordinator) in childCoordinators.enumerated() {
                if (coordinator === aCoordinator) {
                    print("     Remving ",aCoordinator)
                    childCoordinators.remove(at: index)
                    break
                }
            }
        }
    }
    
    func gotoAGroup(GroupID anID:Int,GroupImage anImage:UIImage,GroupName aName : String){
        let vc = GroupViewController.instantiate()
        vc.coordinator = self
        vc.currentID = anID
        vc.currentGroupName = aName
        vc.currentGroupImage = anImage
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = SepantaGroupsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

}
