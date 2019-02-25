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
    
    func mountTokenToHeaders() {
        NetworkManager.shared.headers["Authorization"] = "Bearer "+LoginKey.shared.token
    }
    
    func start() {
        if LoginKey.shared.isLoggedIn() {
            // Go to HomeViewController
            LoginKey.shared.retrieveTokenAndUserID()
            //print("Already Logged in with token : ",LoginKey.shared.token)
            mountTokenToHeaders()
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            childCoordinators.append(homeCoordinator)
            homeCoordinator.parentCoordinator = self
            homeCoordinator.start()

        } else {
            // Go to Login Controller
            print("Not Logged in Yet/ or logged out before")
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            childCoordinators.append(loginCoordinator)
            loginCoordinator.parentCoordinator = self
            loginCoordinator.start()
        }
    }

}
