//
//  HomePageController.swift
//  Sepanta
//
//  Created by Iman on 11/30/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

class HomeCoordinator: NSObject,Coordinator,UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var menuOpened = false
    var myDisposeBag = DisposeBag()
    var navigationController: UINavigationController
    /* parentCoordinator could be either AppCoordinator or LoginCoordinator */
    weak var parentCoordinator : AppCoordinator?


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
        case 2:
            popHome()
            pushNearest()
            break
        case 3:
            popHome()
            pushNewShops()
            break
        case 4:
            popHome()
            pushGetRich(nil)
            break
        case 5:
            popHome()
            pushAboutUs()
            break
        case 6:
            popHome()
            pushContactUs()
            break
        case 7:
            print("Menu Logout!")
            break

        default:
            print("Wrong Menu Number")
            fatalError()
        }

    }
    
    func popOneLevel(){
            print("*** POPING One Level....")
            navigationController.topViewController?.willPop()
            navigationController.popViewController(animated: true)
    }
    
    func popHome() {
        while !navigationController.topViewController!.isKind(of: HomeViewController.self) {
            print("Poping ",navigationController.topViewController ?? "Nil")
            navigationController.topViewController?.willPop()
            navigationController.popViewController(animated: false)
        }
    }
    
    func popLogin(Set mobileNumber : String = "") {
        while !navigationController.topViewController!.isKind(of: LoginViewController.self) {
            print("popLogin is Poping ",navigationController.topViewController ?? "Nil")
            navigationController.topViewController?.willPop()
            navigationController.popViewController(animated: false)
        }
        if let vc = navigationController.topViewController as? LoginViewController {
            vc.doSubscribtions()
        }else{
            fatalError()
        }
    }

    func openButtomMenu (){
        let menuVC = MenuViewController.instantiate()
        menuVC.coordinator = self
        navigationController.delegate = self
        navigationController.showDetailViewController(menuVC, sender: self)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushAboutUs() {
        let storyboard = UIStoryboard(name: "ContactAboutUS", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
        //let vc = AboutUsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushShowProfile (){

        if LoginKey.shared.role == "Shop" {
            let ashop = Shop(WithUserID: Int(LoginKey.shared.userID))
            self.pushShop(Shop: ashop)
        }else{
            let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            //let vc = ProfileViewController.instantiate()
            vc.coordinator = self
            navigationController.delegate = self
            navigationController.pushViewController(vc, animated: true)
            navigationController.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func pushEditProfile (){
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        let vc = EditProfileViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushShop(Shop ashop : Shop){
        let storyboard = UIStoryboard(name: "Shop", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        //let vc = ShopViewController.instantiate()
        vc.coordinator = self
        vc.shop = ashop
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func pushSepantaieGroup (){
        let storyboard = UIStoryboard(name: "SepantaGroup", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SepantaGroupsViewController") as! SepantaGroupsViewController
        //let vc = SepantaGroupsViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushAGroup(GroupID anID:Int,GroupImage anImage:UIImage,GroupName aName : String,State astate : String?,City acity : String?,StateStr astateStr : String?,CityStr acityStr : String?){
        let storyboard = UIStoryboard(name: "SepantaGroup", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
        //let vc = GroupViewController.instantiate()
        vc.coordinator = self
        vc.catagoryId = anID
        vc.currentGroupName = aName
        vc.currentGroupImage = anImage
        vc.selectedCity = acity
        vc.selectedState = astate
        vc.selectedStateStr = astateStr
        vc.selectedCityStr = acityStr
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushGetRich(_ aCardNo : String?){
        let storyboard = UIStoryboard(name: "GetRich", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "GetRichViewController") as! GetRichViewController
        //let vc = GetRichViewController.instantiate()
        vc.coordinator = self
        vc.cardNo = aCardNo
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushNewShops(){
        SlidesAndPaths.shared.count_new_shop.accept(0)
        let storyboard = UIStoryboard(name: "Shop", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopsListViewController") as! ShopsListViewController
        //let vc = ShopsListViewController.instantiate()
        vc.coordinator = self
        vc.fetchMechanism = { aShopListViewController in
            let shopsDataSource = ShopsListDataSource(aShopListViewController)
            shopsDataSource.getNewShopsFromServer()
            return shopsDataSource
        }
        vc.headerLabelToSet = "جدیدترین ها"
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func pushHelp() {
        let storyboard = UIStoryboard(name: "Help", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        //let vc = ShopsListViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushMyFollowingShops(){
        let storyboard = UIStoryboard(name: "Shop", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopsListViewController") as! ShopsListViewController
//        let vc = ShopsListViewController.instantiate()
        vc.coordinator = self
        vc.fetchMechanism = { aShopListViewController in
            let shopsDataSource = ShopsListDataSource(aShopListViewController)
            shopsDataSource.getMyFollowingFromServer()
            return shopsDataSource
        }
        vc.headerLabelToSet = "باشگاه های من"
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushFavoriteList(){
        let storyboard = UIStoryboard(name: "Shop", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavListViewController") as! FavListViewController
        vc.coordinator = self
        vc.fetchMechanism = { sFavListViewController in
            let shopsDataSource = FavListDataSource(sFavListViewController)
            shopsDataSource.getFavShopsFromServer()
            return shopsDataSource
        }
        vc.headerLabelToSet = "علاقه مندی ها"
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func PushAPost(PostID aPostID : Int,OwnerUserID auserid : Int){
        let storyboard = UIStoryboard(name: "Post", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        //let vc = PostViewController.instantiate()
        vc.coordinator = self
        vc.postID = aPostID
        vc.postOwnerUserID = auserid
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
    
    
    func pushNotifications(){
        //Reset Notification Badge
        SlidesAndPaths.shared.notifications_count.accept(0)
        let storyboard = UIStoryboard(name: "Notifications", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        vc.coordinator = self
        
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushNearest(){        
        let storyboard = UIStoryboard(name: "Map", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "NearestViewController") as! NearestViewController
        vc.coordinator = self
        vc.mapMode = MapType.NearbyShops
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }


    func pushShopMapOrPopMapVC(_ ashop : Shop){
        var isMapLoaded = false
        for avc in navigationController.viewControllers
        {
            if avc.isKind(of: NearestViewController.self) {
                print("In Memory!")
                isMapLoaded = true
            }
        }
        if isMapLoaded {
            while !navigationController.topViewController!.isKind(of: NearestViewController.self) {
                print("Poping ",navigationController.topViewController ?? "Nil")
                navigationController.popViewController(animated: true)
            }
            let mapVC = (navigationController.topViewController as! NearestViewController)
            mapVC.shopToShow = ashop
            mapVC.showSingleShop()
        }else{
            self.pushShopMap(ashop)
        }

    }
    
    func pushShopMap(_ ashop : Shop){
        let storyboard = UIStoryboard(name: "Map", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "NearestViewController") as! NearestViewController
        vc.coordinator = self
        vc.mapMode = MapType.SingleShop
        vc.shopToShow = ashop
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushContactUs(){
        let storyboard = UIStoryboard(name: "ContactAboutUS", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUSViewController") as! ContactUSViewController
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    func pushNewCard(){
        let storyboard = UIStoryboard(name: "NewCard", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewCardViewController") as! NewCardViewController
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushScores(){
        let storyboard = UIStoryboard(name: "Scores", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScoresViewController") as! ScoresViewController
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushEditShop(Shop ashop : Shop){
        let storyboard = UIStoryboard(name: "Shop", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditShopViewController") as! EditShopViewController
        vc.coordinator = self
        vc.shop = ashop
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    
    func pushHomePage() {
        mountTokenToHeaders()
        _ = SlidesAndPaths.shared
        _ = ProfileInfoWrapper.shared        
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func mountTokenToHeaders() {
        NetworkManager.shared.headers["Authorization"] = "Bearer "+LoginKey.shared.token
        //print("Header Mounted : ",NetworkManager.shared.headers["Authorization"]?.count)
    }
    
    func pushLoginPage() {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushSMSVerification(Set mobileNumber : String) {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SMSConfirmViewController") as! SMSConfirmViewController
//        let vc = SMSConfirmViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        vc.mobileNumber = mobileNumber
    }
    
    func pushSignup() {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
//        let vc = SignupViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    
    func pushAddPost(){
        let storyboard = UIStoryboard(name: "Post", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func pushEditPost(shop_id : Int, post_id : Int, post_title : String,post_body: String, post_image : UIImage){
        let storyboard = UIStoryboard(name: "Post", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        vc.coordinator = self
        vc.shop_id = shop_id
        vc.post_id = post_id
        vc.postTitle = post_title
        vc.postBody = post_body
        vc.postUIImage = post_image
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        pushLoginPage()
        if LoginKey.shared.isLoggedIn() {
            // Go to HomeViewController
            /*let retriveResult*/ _ = LoginKey.shared.retrieveTokenAndUserID()
            //print("Already Logged in with token : ",LoginKey.shared.token," Retriving : ",retriveResult)
            pushHomePage()
        }
    }
}
