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

class ShopCell : UITableViewCell {
    
}

class GroupViewController :  UIViewControllerWithCoordinator,UITextFieldDelegate,Storyboarded{
    let myDisopseBag = DisposeBag()
    let shops : BehaviorRelay<[Shop]> = BehaviorRelay(value: [])

    @IBOutlet weak var shopTable: UITableView!
    
    func fetchData() {
        shops.accept([Shop(name: "نام رستوران", image: "cat_img/icon_menu_02.png", stars: 3.4, followers: 1200, dicount: 10)])
    }
    func bindToTableView() {

        shops.bind(to: shopTable.rx.items(cellIdentifier: "cell")) { row, model, cell in
            cell.textLabel?.text = "\(model.name), \(model.followers)"
            }.disposed(by: myDisopseBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToTableView()
        fetchData()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func gotoHomePage(_ sender: Any) {
        if let coord = coordinator as? GroupsCoordinator {
            coord.parentCoordinator?.start()
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        coordinator?.start()
    }
    
}
