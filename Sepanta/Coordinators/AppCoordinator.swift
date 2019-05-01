//
//  AppCoordinator.swift
//  Sepanta
//
//  Created by Iman on 11/24/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func removeChild(_ aCoordinator : Coordinator){
        
        for (index,coordinator) in childCoordinators.enumerated() {
            if (coordinator === aCoordinator) {
                childCoordinators.remove(at: index)
                print("     AppCoord Removing ",aCoordinator)
                break
            }
        }
        
    }


    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
    }

}
