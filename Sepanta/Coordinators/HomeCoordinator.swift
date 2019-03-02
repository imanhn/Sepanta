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
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
    }
    var centerViewController: HomeViewController!
    var leftViewController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //UINavigationControllerDelegate.navigationController Called after a new view is shown, So I am going to remove current Coordinator
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("HomeCoordinator : didShow ",viewController)
        print("All ViewControllers in NavigationViewController : ",navigationController.viewControllers)
        print(" Transition : ",navigationController.transitionCoordinator)
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            print("Unknown fromViewController!")
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            print("HOMECoord : from view : " ,fromViewController)
            return
        }
        
        if let aSMSConfirmViewController = fromViewController as? SMSConfirmViewController {
            print("HomeCoordinator : Removing aSMSConfirmViewController")
            SMSConfirmViewControllerFinsihed(aSMSConfirmViewController)
        }
        if let sepantaGroupsViewController = fromViewController as? SepantaGroupsViewController {
            print("HomeCoordinator : Removing sepantaGroupsViewController")
            SepantaGroupsViewControllerFinished(sepantaGroupsViewController)
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
                    print("     Remving ",aCoordinator)
                    break
                }
            }
        }
    }
    

    func SMSConfirmViewControllerFinsihed(_ aSMSConfirmViewController : SMSConfirmViewController?) {
        removeChild(aSMSConfirmViewController)
    }
    func SepantaGroupsViewControllerFinished(_ sepantaGroupsViewController : SepantaGroupsViewController?) {
        removeChild(sepantaGroupsViewController)
    }

    func gotoSepantaieGroups (){

        let groupsCoordinator = GroupsCoordinator(navigationController: navigationController)
        childCoordinators.append(groupsCoordinator)
        groupsCoordinator.parentCoordinator = self
        groupsCoordinator.start()

    }

    func popMenu(_ aViewControllerWithMenu : UIViewController) {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            let vc = SidePanelViewController()
//            aViewControllerWithMenu.view.insertSubview(vc.view, at: 0)
            navigationController.addChildViewController(vc)
            navigationController.view.insertSubview(vc.view, at: 0)
            //aViewControllerWithMenu.addChildViewController(vc)
            vc.didMove(toParentViewController: aViewControllerWithMenu)
            self.centerViewController = aViewControllerWithMenu as! HomeViewController
            self.leftViewController = vc
            //addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded,CenterViewController: aViewControllerWithMenu)
        /*
        
 
 */
    }
    
    func animateLeftPanel(shouldExpand: Bool,CenterViewController acenterVC : UIViewController) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: acenterVC.view.frame.width - centerPanelExpandedOffset,CenterViewController: acenterVC)
            //        targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0,CenterViewController: acenterVC) { finished in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    func animateCenterPanelXPosition(targetPosition: CGFloat,CenterViewController acenterVC : UIViewController, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        acenterVC.view.frame.origin.x = targetPosition;
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            navigationController.view.layer.shadowOpacity = 0.8
        } else {
            navigationController.view.layer.shadowOpacity = 0.0
        }
    }
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
