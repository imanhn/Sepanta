//
//  AboutUs.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class AboutUsCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var menuOpened = false
    var navigationController: UINavigationController
    weak var parentCoordinator : Coordinator?
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //UINavigationControllerDelegate.navigationController Called after a new view is shown, So I am going to remove current Coordinator
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //self.navigationController =  UINavigationController()
        print("HomeCoordinator : didShow ",viewController)
        //navigationController.viewControllers.remove(at: 0)
        print("All ViewControllers in NavigationViewController : ",navigationController.viewControllers)
        print("All childcoordinators : ",childCoordinators)
        //print(" Transition : ",navigationController.transitionCoordinator)
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            //print("Unknown fromViewController!")
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            //print("HOMECoord : from view : " ,fromViewController)
            return
        }
        
        if let aSMSConfirmViewController = fromViewController as? SMSConfirmViewController {
            print("HomeCoordinator : Removing aSMSConfirmViewController")
            removeChild(aSMSConfirmViewController.coordinator!)
            //SMSConfirmViewControllerFinsihed(aSMSConfirmViewController.coordinator)
        }
        if let sepantaGroupsViewController = fromViewController as? SepantaGroupsViewController {
            print("HomeCoordinator : Removing sepantaGroupsViewController")
            removeChild(sepantaGroupsViewController.coordinator!)
            //SepantaGroupsViewControllerFinished(sepantaGroupsViewController.coordinator)
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
    
    func launchMenuSelection(_ aRow : Int) {
        switch aRow {
        case 0:
            gotoHome()
            break
        case 1:
            gotoSepantaieGroups()
            break
        case 4:
            gotoGetRich()
            break
        case 5:
            print("Already there!")
            break
            
        default:
            print("Wrong Menu Number")
            fatalError()
        }
        
    }
    
    func goBack(){
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.removeChild(self)
    }
    func openButtomMenu (){
        let menuCoordinator = MenuCoordinator(navigationController: navigationController)
        childCoordinators.append(menuCoordinator)
        menuCoordinator.parentCoordinator = self
        menuCoordinator.start()
    }
    
    
    func gotoGetRich() {
        let getRichCoordinator = GetRichCoordinator(navigationController: navigationController)
        childCoordinators.append(getRichCoordinator)
        getRichCoordinator.parentCoordinator = self
        getRichCoordinator.start()
        
    }
    
    func gotoHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
        
    }
    func gotoSepantaieGroups (){
        let groupsCoordinator = GroupsCoordinator(navigationController: navigationController)
        childCoordinators.append(groupsCoordinator)
        groupsCoordinator.parentCoordinator = self
        groupsCoordinator.start()
        
    }
    
    
    func start() {
        
        let vc = AboutUsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
