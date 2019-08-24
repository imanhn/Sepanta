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

struct ButtomMenuItem: Decodable {
    let aLabel: String
    let anImageName: String
}

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var menuCellLabel: UILabel!
    @IBOutlet weak var menuCellImage: UIImageView!
}

class MenuViewController: UIViewController, Storyboarded, UITableViewDelegate {
    weak var coordinator: HomeCoordinator?
    @IBOutlet weak var menuTableView: MenuTableView!
    let myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    @IBOutlet weak var menuTableViewHeightCons: NSLayoutConstraint!

    var menuItems: BehaviorRelay<[ButtomMenuItem]> = BehaviorRelay(value: [])

    @IBAction func backFromMenuTapped(_ sender: Any) {
        removeMenuAndDismissVC()
    }

    func removeMenuAndDismissVC() {
        print("Dismissing menu...")
        menuItems  = BehaviorRelay<[ButtomMenuItem]>(value: [ButtomMenuItem]())
        disposeList.forEach({$0.dispose()})
        //self.removeFromParentViewController()
        self.dismiss(animated: true, completion: {})
    }

    func loadMenuItems() {
        var items = [ButtomMenuItem]()
        items.append(ButtomMenuItem(aLabel: "پروفایل", anImageName: "icon_mainmenu_03")) //0
        items.append(ButtomMenuItem(aLabel: "مراکز سپنتایی", anImageName: "icon_mainmenu_04")) //1
        items.append(ButtomMenuItem(aLabel: "نزدیک من", anImageName: "icon_mainmenu_05")) //2
        items.append(ButtomMenuItem(aLabel: "جدیدترین ها", anImageName: "icon_mainmenu_06"))//3
        items.append(ButtomMenuItem(aLabel: "پولدار شو", anImageName: "icon_mainmenu_07"))//4
        items.append(ButtomMenuItem(aLabel: "درخواست نمایندگی", anImageName: "delegacy_icon"))//5
        items.append(ButtomMenuItem(aLabel: "درباره ما", anImageName: "icon_mainmenu_08"))//6
        items.append(ButtomMenuItem(aLabel: "ارتباط با ما", anImageName: "icon_mainmenu_09"))//7
        items.append(ButtomMenuItem(aLabel: "خروج از حساب کاربری", anImageName: "icon_logout_white2"))//8
        menuItems.accept(items)
    }

    func bindToTableView() {
        let menuItemDisp = menuItems.bind(to: menuTableView.rx.items(cellIdentifier: "menuCell")) { _, model, cell in
            if let aCell = cell as? MenuItemCell {
                aCell.menuCellLabel.text = model.aLabel
                aCell.menuCellImage.image =  UIImage(named: model.anImageName)
                self.menuTableView.rowHeight = UIScreen.main.bounds.height*(self.menuTableViewHeightCons.multiplier)/CGFloat(self.menuItems.value.count)
            }
        }
        menuItemDisp.disposed(by: myDisposeBag)
        disposeList.append(menuItemDisp)

        let selectDisp = Observable
            .zip(menuTableView.rx.itemSelected, menuTableView.rx.modelSelected(ButtomMenuItem.self))
            .bind { [unowned self] indexPath, model in
                self.menuTableView.deselectRow(at: indexPath, animated: true)
                print("Selected " + model.aLabel + " at \(indexPath)")
                guard self.coordinator != nil else {
                    print("MenuViewController : Coordinator for MenuViewController is nil")
                    return
                }

                if indexPath.row == 8 {
                    //print("Option Menu : 7")
                    self.logout()
                } else {
                    self.coordinator?.launchMenuSelection(indexPath.row)
                    self.removeMenuAndDismissVC()
                }
            }
        selectDisp.disposed(by: myDisposeBag)
        disposeList.append(selectDisp)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Removing Subscription for MenuVC")
        disposeList.forEach({$0.dispose()})
    }

    override func viewDidLoad() {
        loadMenuItems()
        menuTableView.menuViewController = self
        bindToTableView()
    }

    func logout() {
        print("showing Question")
        _ = self.showQuestion(Message: "آیا می خواهیداز پروفایل خود خارج شوید؟", OKLabel: "بلی", CancelLabel: "خیر", OkAction: {
            self.removeMenuAndDismissVC()
            LoginKey.shared.deleteTokenAndUserID()
            self.coordinator!.popLogin()
        }, CancelAction: {self.removeMenuAndDismissVC()})
    }
}

class MenuTableView: UITableView {
    weak var menuViewController: MenuViewController!
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let aview = super.hitTest(point, with: event)
        if point.y < 0 {
            menuViewController?.backFromMenuTapped(self)
        }
        return aview
    }
}
