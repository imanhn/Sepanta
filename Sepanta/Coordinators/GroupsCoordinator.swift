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
        //print(" Transition : ",navigationController.transitionCoordinator)
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            //print("NO FROM!")
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            print("GroupCoord : from view : " ,fromViewController)
            return
        }

        if let sepantaGroupsViewController = fromViewController as? SepantaGroupsViewController {
            print("GroupCoordinator : Removing Sepanta Coordinator..")
            //sepantaGroupsViewController.dismiss(animated: true, completion: {})
            //removeChild(sepantaGroupsViewController.coordinator!)
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
    func goBack(){
        navigationController.popViewController(animated: false)
    }
    
    func gotoHomeFromAGroups(){
        navigationController.popViewController(animated: false)
        gotoHomeFromSepantaieGroups()
    }
    func gotoHomeFromSepantaieGroups(){
        (navigationController.topViewController as! SepantaGroupsViewController).groupButtons = nil
        navigationController.popViewController(animated: false)
        
        guard self.parentCoordinator != nil else {
            print("Parent is nil : ",self.parentCoordinator)
            return
        }
        self.parentCoordinator?.removeChild(self)
        /*
        let aCoord = HomeCoordinator(navigationController: self.navigationController)
        //aCoord.parentCoordinator = self
        print("Starting HomeCoordinator...")
        aCoord.start()
 */
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
        print("SepGr cor : ",vc.coordinator)
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

}
