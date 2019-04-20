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
    /* parentCoordinator could be either AppCoordinator or LoginCoordinator */
    weak var parentCoordinator : Coordinator?


    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func removeChild(_ aCoordinator : Coordinator){

        for (index,coordinator) in childCoordinators.enumerated() {
            if (coordinator === aCoordinator) {
                childCoordinators.remove(at: index)
                print("     HomeCoord Removing ",aCoordinator)
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
    
    func pushShop(Shop ashop : Shop){
        let vc = ShopViewController.instantiate()
        vc.coordinator = self
        vc.shop = ashop
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
    
    func pushAGroup(GroupID anID:Int,GroupImage anImage:UIImage,GroupName aName : String,State astate : String?,City acity : String?){
        let vc = GroupViewController.instantiate()
        vc.coordinator = self
        vc.catagoryId = anID
        vc.currentGroupName = aName
        vc.currentGroupImage = anImage
        vc.selectedCity = acity
        vc.selectedState = astate
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
    
    func PushAPost(PostID aPostID : Int){
        let vc = PostViewController.instantiate()
        vc.coordinator = self
        vc.postID = aPostID
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func PushSearch(Keyword keyword:String){
        let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        //var vc = SearchViewController.instantiate()
        vc.coordinator = self
        vc.keyword = keyword
        
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func logout() {
        LoginKey.shared.deleteTokenAndUserID()
        if self.parentCoordinator != nil{
            //print("removing \(self) from \(self.parentCoordinator)")
            self.parentCoordinator?.removeChild(self)
            print("Running Logout on parent coordinator(loginCoord)")
            if let appCoord = self.parentCoordinator as? AppCoordinator {
                appCoord.start()
            }else if let loginCoord = self.parentCoordinator as? LoginCoordinator{ // in Case : User AppCoord Logins (LoginCoord) -> Home (HomeCoord) -> Logout
                if let appCoord = loginCoord.parentCoordinator {
                    appCoord.removeChild(loginCoord)
                    appCoord.start()
                    print("HomeCoord : Program should not get here!")
                }
            }
        }else{
            print("HomeCoord : parentCoordinator is NIL!")
        }
    }
    
    func start() {
        _ = SlidesAndPaths.shared
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}
