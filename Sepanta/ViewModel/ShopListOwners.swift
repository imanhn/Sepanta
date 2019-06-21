//
//  ShopListOwnersOffImage.swift
//  Sepanta
//
//  Created by Iman on 3/19/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

protocol ShopListOwners : class {
    typealias dataSourceFunc = (UIViewController) -> ShopsListDataSource
    var fetchMechanism : dataSourceFunc! { get set }
    var dataSource : RxTableViewSectionedAnimatedDataSource<SectionOfShopData>! {get set}
    var shopsObs : BehaviorRelay<[Shop]> {get set}
    var sectionOfShops : BehaviorRelay<[SectionOfShopData]> { get set }
    var maximumFontSize : CGFloat! { get set }
    var disposeList : [Disposable] { get set }
    var myDisposeBag : DisposeBag { get set}
    var shopTable: UITableView! { get set }
    func CreateOffImage(Off offNo : String,ViewSize : CGSize)->UIImage
    func findMaximumFontSize(ViewSize : CGSize) -> CGFloat
    func bindToTableView()
    func pushAShop(_ selectedShop : Shop)
}

extension ShopListOwners where Self:UIViewControllerWithErrorBar{
    
    func findMaximumFontSize(ViewSize : CGSize) -> CGFloat{
        
        var stillFit = true
        var FontSize : CGFloat = 10
        while stillFit {
            if ViewSize.width < "88%".width(withConstrainedHeight: ViewSize.height, font: UIFont (name: "Shabnam-Bold-FD", size: FontSize)!)
            {
                stillFit = false
                break
            }else{
                FontSize = FontSize + 1
            }
        }
        return (FontSize - 1)
    }
    
    func CreateOffImage(Off offNo : String,ViewSize : CGSize)->UIImage{
        let backgroundImage = UIImage(named: "off")
        UIGraphicsBeginImageContextWithOptions(ViewSize, false, 0)
        let areaSize = CGRect(x: 0, y: 0, width: ViewSize.width, height: ViewSize.height)
        backgroundImage?.draw(in: areaSize)
        let textBox = CGRect(x: 2+ViewSize.width/8 , y: 2+ViewSize.height/8, width: ViewSize.width*3/4, height: ViewSize.height*3/4)
        if self.maximumFontSize == nil {
            self.maximumFontSize = self.findMaximumFontSize(ViewSize: textBox.size)
        }
        
        //let textBox = CGRect(x: size.width/4 , y: size.height/4, width: size.width/2, height: size.height/2)
        let lab = UILabel(frame: textBox)
        lab.text = "\(offNo)%"
        lab.font = UIFont (name: "Shabnam-Bold-FD", size: maximumFontSize)!
        //lab.adjustsFontSizeToFitWidth = true
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        lab.adjustsFontSizeToFitWidth = true
        lab.drawText(in: textBox)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let shadowImage = newImage.addShadow(blurSize: 4)
        return shadowImage
    }
    
    func bindToTableView() {
        shopTable.tableFooterView = UIView()
        //let shopObsDisp = NetworkManager.shared.shopObs
        let shopObsDisp = shopsObs.subscribe(onNext: { shops in
                let initsec = SectionOfShopData(original: SectionOfShopData(header: "Header", items: [Shop]()), items: shops)
                self.sectionOfShops.accept([initsec])
                self.shopTable.reloadData()
            })
        shopObsDisp.disposed(by: myDisposeBag)
        disposeList.append(shopObsDisp)
        
        dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfShopData>(configureCell: { dataSource, tableView, indexPath, item in
            //let row = indexPath.row
            let model = item
            let cell = self.shopTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var returningCell : ShopCell!
            if let aCell = cell as? ShopCell {
                aCell.shopName.text = model.shop_name
                let persianDiscount :String = "\(model.shop_off ?? 0)".toPersianNumbers()
                //aCell.discountPercentage.text = persianDiscount+"%"
                aCell.offImage.image = self.CreateOffImage(Off: persianDiscount,ViewSize: aCell.offImage.frame.size)
                let persianFollowers :String = "\(model.follower_count ?? 0)".toPersianNumbers()
                aCell.shopFollowers?.text = persianFollowers
                let persianRate :String = "\(model.rate_count ?? 0)".toPersianNumbers()
                let rate : Float = Float(model.rate ?? "0.0") ?? 0
                aCell.rateLabel?.text = "("+persianRate+")"
                aCell.star1?.image = UIImage(named: "icon_star_gray")
                aCell.star2?.image = UIImage(named: "icon_star_gray")
                aCell.star3?.image = UIImage(named: "icon_star_gray")
                aCell.star4?.image = UIImage(named: "icon_star_gray")
                aCell.star5?.image = UIImage(named: "icon_star_gray")
                if rate > 0.5 {aCell.star1?.image = UIImage(named: "icon_star_on")}
                if rate > 1.5 {aCell.star2?.image = UIImage(named: "icon_star_on")}
                if rate > 2.5 {aCell.star3?.image = UIImage(named: "icon_star_on")}
                if rate > 3.5 {aCell.star4?.image = UIImage(named: "icon_star_on")}
                if rate > 4.5 {aCell.star5?.image = UIImage(named: "icon_star_on")}
                if let shopImage = aCell.shopImage{
                    //print("NetworkManager.shared.websiteRootAddress : ",NetworkManager.shared.websiteRootAddress)
                    //print("SlidesAndPaths.shared.path_profile_image : ",SlidesAndPaths.shared.path_profile_image)
                    //print("model.image : ",model.image)
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.image ?? ""))
                    {
                        //print("imageURL : ",imageUrl.absoluteString)
                        shopImage.setImageFromCache(PlaceHolderName :"logo_shape_in", Scale : 0.8 ,ImageURL : imageUrl ,ImageName : (model.image ?? ""))
                    }else{
                        print("model.image path could not be cast to URL  : ",model.image ?? "(model.image is nil)")
                        
                    }
                    
                }
                
                returningCell = aCell
            }
            return returningCell ?? cell
            
        })
        //NetworkManager.shared.shopObs
        let sectionDisp =  sectionOfShops
            .bind(to: shopTable.rx.items(dataSource: dataSource))
        sectionDisp.disposed(by: myDisposeBag)
        disposeList.append(sectionDisp)
        
        
        let shopSelectDisp = shopTable.rx.modelSelected(Shop.self)
            .subscribe(onNext: { [unowned self] selectedShop in
                //print("Pushing ShopVC with : ", selectedShop)
                //self.coordinator!.pushShop(Shop: selectedShop)
                self.pushAShop(selectedShop)
            })
        shopSelectDisp.disposed(by: myDisposeBag)
        disposeList.append(shopSelectDisp)
 
    }
}
