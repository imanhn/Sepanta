//
//  GetRichCoordinator.swift
//  Sepanta
//
//  Created by Iman on 12/14/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class GetRichCoordinator : NSObject,Coordinator,UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator : Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
            navigationController.popViewController(animated: false)
            print("Dashboard Coordinator")
            break
        case 1:
            gotoSepantaieGroups()
            break
        case 4:
            gotoGetRich()
            break
        default:
            print("Wrong Menu Number")
            fatalError()
        }
        
    }
    
    func gotoGetRich() {
        // Do Nothing! Just Close the menu!
        
    }
    
    func gotoSepantaieGroups (){
        // First Goto Home
        navigationController.popViewController(animated: false)
        // remove GetRichCoordinator, Assuming GetRichCoord parent is HomeCoord
        guard self.parentCoordinator != nil else {
            print("GetRichCoordinator.parent is Nil")
            return
        }
        (self.parentCoordinator! as! HomeCoordinator).removeChild(self)
        (self.parentCoordinator! as! HomeCoordinator).gotoSepantaieGroups()
    }
    
    func openButtomMenu (){
        let menuCoordinator = MenuCoordinator(navigationController: navigationController)
        childCoordinators.append(menuCoordinator)
        menuCoordinator.parentCoordinator = self
        menuCoordinator.start()
    }
    
    func start() {
        let vc = GetRichViewController.instantiate()
        vc.coordinator = self
        print("getRich Coord : ",vc.coordinator)
        self.navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

