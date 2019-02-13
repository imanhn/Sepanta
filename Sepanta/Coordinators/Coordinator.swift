//
//  Coordinator.swift
//  Sepanta
//
//  Created by Iman on 11/24/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator:AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
