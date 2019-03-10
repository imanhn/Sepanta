//
//  NewShopsViewController.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class NewShopCell : UITableViewCell {
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

class NewShopsViewController :  UIViewController,Storyboarded{
    weak var coordinator : HomeCoordinator?
    let myDisposeBag = DisposeBag()
    let shops : BehaviorRelay<[Shop]> = BehaviorRelay(value: [])
    var newShopsDataSource : NewShopsDataSource!
    
    @IBOutlet weak var shopTable: UITableView!
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }

    func bindToTableView() {
        
        shops.bind(to: shopTable.rx.items(cellIdentifier: "cell")) { row, model, cell in
            if let aCell = cell as? NewShopCell {
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
                    shopImage.af_setImage(withURL: imageUrl, filter: filter,imageTransition: .crossDissolve(0.4))
                }
            }
            }.disposed(by: myDisposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToTableView()
        newShopsDataSource = NewShopsDataSource(self)
        newShopsDataSource.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        newShopsDataSource = nil
    }
    
}







