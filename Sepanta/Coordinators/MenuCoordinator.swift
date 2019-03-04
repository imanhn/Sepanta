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
    weak var parentCoordinator : HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func menuDismissed() {        
        guard self.parentCoordinator != nil else {
            print("Menu Coordinator : Parent is nil : ",self.parentCoordinator)
            return
        }
        self.parentCoordinator?.removeChild(self)
    }
    
    func menuSelected(IndexPath anIndexPath : IndexPath){
        guard self.parentCoordinator != nil else {
            print("Menu Coordinator : Parent is nil : ",self.parentCoordinator)
            return
        }
        self.parentCoordinator?.removeChild(self)
        self.parentCoordinator?.launchMenuSelection(anIndexPath.row)
    }
    
    func start(){
        let menuVC = MenuViewController.instantiate()
        menuVC.coordinator = self
        navigationController.delegate = self
        navigationController.showDetailViewController(menuVC, sender: self)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
