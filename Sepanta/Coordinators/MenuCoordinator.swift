//
//  MenuCoordinator.swift
//  Sepanta
//
//  Created by Iman on 12/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class MenuCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    
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

    func menuDismissed() {        
        guard self.parentCoordinator != nil else {
            //print("Menu Coordinator : Parent is nil : ",self.parentCoordinator)
            return
        }
        self.parentCoordinator?.removeChild(self)
    }
    
    func menuSelected(IndexPath anIndexPath : IndexPath){
        guard self.parentCoordinator != nil else {
            //print("Menu Coordinator : Parent is nil : ",self.parentCoordinator)
            return
        }
        self.parentCoordinator?.removeChild(self)
        if let parent = self.parentCoordinator! as? HomeCoordinator {
            parent.launchMenuSelection(anIndexPath.row)
        }else{
            print("MenuCoordinator : my parent can not be casted to HomeCoordinator!")
        }
    }
    
    func start(){
        let menuVC = MenuViewController.instantiate()
        menuVC.coordinator = self
        navigationController.delegate = self
        navigationController.showDetailViewController(menuVC, sender: self)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
