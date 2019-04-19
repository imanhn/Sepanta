//
//  MenuViewController.swift
//  Sepanta
//
//  Created by Iman on 12/12/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

struct ButtomMenuItem : Decodable {
    let aLabel : String
    let anImageName : String
}

class MenuItemCell : UITableViewCell {
    @IBOutlet weak var menuCellLabel: UILabel!
    @IBOutlet weak var menuCellImage: UIImageView!
}

class MenuViewController : UIViewController,Storyboarded,UITableViewDelegate {
    weak var coordinator : MenuCoordinator?
    @IBOutlet weak var menuTableView: UITableView!
    let myDisposeBag = DisposeBag()
    let menuItems : BehaviorRelay<[ButtomMenuItem]> = BehaviorRelay(value: [])
    
    @IBAction func backFromMenuTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        guard self.coordinator != nil else {
            print("Coordinator of MenuViewController is nil")
            return
        }
        self.coordinator?.menuDismissed()    
    }
    
    func loadMenuItems() {
        var items = [ButtomMenuItem]()
        items.append(ButtomMenuItem(aLabel: "داشبورد", anImageName: "icon_mainmenu_03"))
        items.append(ButtomMenuItem(aLabel: "مراکز سپنتایی", anImageName: "icon_mainmenu_04"))
        items.append(ButtomMenuItem(aLabel: "نزدیک من", anImageName: "icon_mainmenu_05"))
        items.append(ButtomMenuItem(aLabel: "جدیدترین ها", anImageName: "icon_mainmenu_06"))
        items.append(ButtomMenuItem(aLabel: "پولدار شو", anImageName: "icon_mainmenu_07"))
        items.append(ButtomMenuItem(aLabel: "درباره ما", anImageName: "icon_mainmenu_08"))
        items.append(ButtomMenuItem(aLabel: "ارتباط با ما", anImageName: "icon_mainmenu_09"))
        menuItems.accept(items)
    }
    
    func bindToTableView() {
        
        menuItems.bind(to: menuTableView.rx.items(cellIdentifier: "menuCell")) { row, model, cell in
            if let aCell = cell as? MenuItemCell {
                aCell.menuCellLabel.text = model.aLabel
                aCell.menuCellImage.image =  UIImage(named: model.anImageName)
                
            }
            }.disposed(by: myDisposeBag)
        
        Observable
            .zip(menuTableView.rx.itemSelected, menuTableView.rx.modelSelected(ButtomMenuItem.self))
            .bind { [unowned self] indexPath, model in
                self.menuTableView.deselectRow(at: indexPath, animated: true)
                print("Selected " + model.aLabel + " at \(indexPath)")
                (self.coordinator as! MenuCoordinator).menuSelected(IndexPath: indexPath)
                //MenuCoordinator.shared.itemSelected(IndexPath: indexPath)
                self.dismiss(animated: true, completion: {})
            }
            .disposed(by: myDisposeBag)
    }

    override func viewDidLoad() {
        loadMenuItems()
        bindToTableView()
    }
}
