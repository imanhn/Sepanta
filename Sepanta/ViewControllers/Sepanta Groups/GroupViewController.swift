//
//  GroupViewController.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class ShopCell : UITableViewCell {
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopFollowers: UILabel!
    @IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    
}

class GroupViewController :  UIViewController,UITextFieldDelegate,Storyboarded{
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    let shops : BehaviorRelay<[Shop]> = BehaviorRelay(value: [])

    @IBOutlet weak var groupLogoImage: UIImageView!
    @IBOutlet weak var shopTable: UITableView!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    var currentGroupImage = UIImage()
    var currentID = Int()
    var currentGroupName = String()
    
    @IBAction func openButtomMenu(_ sender: Any) {
        self.coordinator?.openButtomMenu()
    }
    
    func updateGroupHeaders(){
        self.HeaderLabel.text = currentGroupName
        self.groupLabel.text = currentGroupName
        self.groupLogoImage.image = currentGroupImage
        self.groupLogoImage.contentMode = .scaleAspectFit
    }
    
    func fetchData() {
        var fetchedShops = [Shop]()
        fetchedShops.append(Shop(user_id: 1,name: "فست فود جو", image: "cat_img/icon_menu_02.png", stars: 1.4, followers: 16005, dicount: 15))
        fetchedShops.append(Shop(user_id: 2,name: "تهران برگر", image: "profile_img/2074-2018-08-28_09-59-03.jpg", stars: 3.4, followers: 1501, dicount: 10))
        
        shops.accept(fetchedShops)
    }

    func bindToTableView() {

        shops.bind(to: shopTable.rx.items(cellIdentifier: "cell")) { row, model, cell in
            if let aCell = cell as? ShopCell {
                aCell.shopName.text = model.name
                let persianDiscount :String = "\(model.dicount)".toPersianNumbers()
                aCell.discountPercentage.text = persianDiscount+"%"
                let persianFollowers :String = "\(model.followers)".toPersianNumbers()
                aCell.shopFollowers.text = persianFollowers
                let persianRate :String = "\(model.stars)".toPersianNumbers()
                aCell.rateLabel.text = "("+persianRate+")"
                if model.stars > 0.5 {aCell.star1.image = UIImage(named: "icon_star_on")}
                if model.stars > 1.5 {aCell.star2.image = UIImage(named: "icon_star_on")}
                if model.stars > 2.5 {aCell.star3.image = UIImage(named: "icon_star_on")}
                if model.stars > 3.5 {aCell.star4.image = UIImage(named: "icon_star_on")}
                if model.stars > 4.5 {aCell.star5.image = UIImage(named: "icon_star_on")}
                if let shopImage = aCell.shopImage {
                    let imageSize = CGSize(width: shopImage.frame.size.width*0.8, height: shopImage.frame.size.height*0.8)
                    let filter = AspectScaledToFitSizeFilter(size: imageSize)
                    
                    let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+"/"+model.image)!
                    let defaultImage = UIImage(named: "logo_shape_in")
                    var cachedData : NSData?
                    if model.image.count > 0
                    {
                        cachedData = CacheManager.shared.readFile(Filename:model.image)
                        if cachedData != nil {
                            //print("Image is already cached ")
                            let cachedImage = UIImage(data: cachedData! as Data)
                            shopImage.image = cachedImage
                        }else{
                            //print("Downloading....")
                            shopImage.af_setImage(withURL: imageUrl, placeholderImage: defaultImage, filter: filter,completion:
                                { (response) in
                                    //print("Image Downloaded,Saving...")
                                    let downloadedImage = shopImage.image!// UIImage(data: response.data!)!
                                    let imageData = UIImagePNGRepresentation(downloadedImage) as NSData?
                                    if imageData != nil {
                                        CacheManager.shared.saveFile(Data:imageData!, Filename:model.image)
                                    }
                                    
                            })
                        }
                    }
                }
            }
            }.disposed(by: myDisposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToTableView()
        fetchData()
        updateGroupHeaders()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func gotoHomePage(_ sender: Any) {
        coordinator!.popHome()        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        coordinator!.popOneLevel()

    }
    
}
