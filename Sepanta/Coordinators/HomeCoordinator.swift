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
    var menuOpened = false
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
            popHome()
            break
        case 1:
            popHome()
            pushSepantaieGroup()
            break
        case 3:
            popHome()
            pushNewShops()
            break
        case 4:
            popHome()
            pushGetRich()
            break
        case 5:
            popHome()
            pushAboutUs()
            break

        default:
            print("Wrong Menu Number")
            fatalError()
        }

    }
    
    func popOneLevel(){
            navigationController.popViewController(animated: true)
    }
    
    func popHome() {
        while !navigationController.topViewController!.isKind(of: HomeViewController.self) {
            print("Poping ",navigationController.topViewController ?? "Nil")
            navigationController.popViewController(animated: false)
        }
    }
    
    func openButtomMenu (){
        let menuCoordinator = MenuCoordinator(navigationController: navigationController)
        childCoordinators.append(menuCoordinator)
        menuCoordinator.parentCoordinator = self
        menuCoordinator.start()
    }
    
    func pushAboutUs() {
        let vc = AboutUsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushShowProfile (){
        let vc = ProfileViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushEditProfile (){
        let vc = EditProfileViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    

    func pushSepantaieGroup (){
        let vc = SepantaGroupsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushAGroup(GroupID anID:Int,GroupImage anImage:UIImage,GroupName aName : String){
        let vc = GroupViewController.instantiate()
        vc.coordinator = self
        vc.currentID = anID
        vc.currentGroupName = aName
        vc.currentGroupImage = anImage
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    func pushGetRich(){
        let vc = GetRichViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushNewShops(){
        let vc = NewShopsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func logout() {
        LoginKey.shared.deleteTokenAndUserID()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        if self.parentCoordinator != nil{
            self.parentCoordinator?.removeChild(self)
        }
        childCoordinators.append(loginCoordinator)
        loginCoordinator.parentCoordinator = nil
        loginCoordinator.start()

    }
    
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
