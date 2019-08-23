//
//  GroupViewControllerFilter.swift
//  Sepanta
//
//  Created by Iman on 3/19/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

extension GroupViewController {
    @objc func sortFilterTapped(_ sender: Any) {
        self.view.endEditing(true)
        let allfilterValues = [byNewest, byName, byRate, byOff, byFollower]
        let controller = ArrayChoiceTableViewController(allfilterValues) {
            (selectedFilter) in
            self.filterView.sortFilter.text = selectedFilter
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterValues.count*45)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.sortFilter)
    }

    @objc func searchFilterTapped(_ sender: Any) {
    }

    func createFilterView() {
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        filterView = FilterView(frame: CGRect(x: self.view.frame.width, y: frameOri.y+headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25))
        filterView.isHidden = true
        self.view.addSubview(filterView)

        filterView.sortFilter.addTarget(self, action: #selector(sortFilterTapped(_:)), for: .allTouchEvents)
        filterView.sortFilter.text = byRate
        filterView.sortFilter.delegate = self

        //filterView.searchFilter.addTarget(self, action: #selector(searchFilterTapped(_:)), for: .allTouchEvents)
        filterView.searchFilter.delegate = self

        filterView.submitButton.addTarget(self, action: #selector(applyFilterTapped), for: .touchUpInside)
    }

    @objc func applyFilterTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let aSearchFilter: SearchFunction = {
            (ashop) -> Bool in
            guard (self.filterView.searchFilter.text ?? "").count > 0 else {return true}
            if let shopName = ashop.shop_name {
                let searchSubString = (self.filterView.searchFilter.text ?? "").CRC()
                if (shopName.contains(searchSubString)) { return true} else {return false}
            } else {return false}
        }
        var sortFunc: SortFunction = { (ashop, bshop) in return true}
        if (self.filterView.sortFilter.text ?? "") == byName {
            sortFunc = { (ashop, bshop) in
                if ((ashop.shop_name ?? "") < (bshop.shop_name ?? "")) {return true} else {return false}
            }
        } else if (self.filterView.sortFilter.text ?? "") == byRate {
            sortFunc = { (ashop, bshop) in
                if ((Int(ashop.rate ?? "0") ?? 0) > (Int(bshop.rate ?? "0") ?? 0)) {return true} else {return false}
            }
        } else if (self.filterView.sortFilter.text ?? "") == byOff {
            sortFunc = { (ashop, bshop) in
                if ((ashop.shop_off ?? "0") > (bshop.shop_off ?? "0")) {return true} else {return false}
            }
        } else if (self.filterView.sortFilter.text ?? "") == byFollower {
            sortFunc = { (ashop, bshop) in
                if ((ashop.follower_count ?? 0) > (bshop.follower_count ?? 0)) {return true} else {return false}
            }
        }
        let aSortedData = SectionOfShopData(original: self.sectionOfShops.value[0], items: self.shopsObs.value, sort: sortFunc, search: aSearchFilter )
        sectionOfShops.accept([aSortedData])
    }

    @IBAction func filterTapped(_ sender: Any) {
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        if filterIsOpen {
            //self.groupHeaderTopCons.constant = 0
            self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
            filterView.isHidden = true

            UIView.animate(withDuration: 1.0) {
                self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
                //self.view.layoutIfNeeded()
                self.groupHeaderTopCons.constant = 0
            }
        } else {
            filterView.isHidden = false
            //self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
            self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)

            UIView.animate(withDuration: 1.0) {
                self.filterView.frame = CGRect(x: 0, y: frameOri.y+self.headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25)
                self.groupHeaderTopCons.constant = UIScreen.main.bounds.height*0.25
                //self.view.layoutIfNeeded()
                //self.filterView.filterType.text = self.searchOption
            }

        }
        filterIsOpen = !filterIsOpen
    }
}
