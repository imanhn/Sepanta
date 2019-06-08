//
//  GroupViewControllerFilter.swift
//  Sepanta
//
//  Created by Iman on 3/19/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

extension GroupViewController {
    @objc func filterValueTapped(_ sender: Any) {
        if self.filterView.filterType.text == searchOption || self.filterView.filterType.text == noFilterOption {
            return
        }
        let allfilterValues = [byNewest,byName,byRate,byOff,byFollower]
        let controller = ArrayChoiceTableViewController(allfilterValues) {
            (selectedFilter) in
            if selectedFilter == self.noFilterOption {
                self.filterView.filterType.isEnabled = false
            }else{
                self.filterView.filterType.isEnabled = true
            }
            self.filterView.filterValue.text = selectedFilter
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterValues.count*45)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.filterValue)
    }
    
    @objc func filterTypeTapped(_ sender : Any){
        let allfilterTypes = [searchOption,sortOption,noFilterOption]
        let controller = ArrayChoiceTableViewController(allfilterTypes) {
            (selectedFilter) in
            self.view.endEditing(true)
            self.filterView.filterType.text = selectedFilter
            if selectedFilter == self.searchOption || selectedFilter == self.noFilterOption{
                self.filterView.filterValue.text = ""
            }else if selectedFilter == self.sortOption {
                self.filterView.filterValue.text = self.byName
            }
        }
        controller.preferredContentSize = CGSize(width: 250, height: allfilterTypes.count*45)
        Spinner.stop()
        self.showPopup(controller, sourceView: filterView.filterValue)
    }
    
    func createFilterView(){
        let frameOri = self.view.convert(headerView.frame.origin, to: self.view)
        filterView = FilterView(frame: CGRect(x: self.view.frame.width, y: frameOri.y+headerView.frame.height, width: self.view.frame.width, height: UIScreen.main.bounds.height*0.25))
        filterView.isHidden = true
        self.view.addSubview(filterView)
        filterView.filterValue.addTarget(self, action: #selector(filterValueTapped(_:)), for: .allTouchEvents)
        filterView.filterType.tag = 1
        filterView.filterValue.tag = 2
        filterView.filterType.text = sortOption
        filterView.filterValue.text = byRate
        filterView.filterType.addTarget(self, action: #selector(filterTypeTapped(_:)), for: .allTouchEvents)
        filterView.filterValue.delegate = self
        filterView.filterType.delegate = self
        filterView.submitButton.addTarget(self, action: #selector(doFilterTapped), for: .touchUpInside)
    }
    
    @objc func doFilterTapped(_ sender : UIButton){
        self.view.endEditing(true)
        if self.filterView.filterType.text == searchOption {
            let aFilteredData = SectionOfShopData(original: self.sectionOfShops.value[0], items: NetworkManager.shared.shopObs.value, filter: {
                (ashop)->Bool in
                guard (self.filterView.filterValue.text ?? "").count > 0 else{return true}
                if let shopName = ashop.shop_name {
                    let searchSubString = (self.filterView.filterValue.text ?? "").CRC()
                    if (shopName.contains(searchSubString)) { return true}else{return false}
                }else{return false}
            })
            sectionOfShops.accept([aFilteredData])
        }else if ((self.filterView.filterValue.text ?? "") == byNewest) || self.filterView.filterType.text == noFilterOption {
            let aNormalList = SectionOfShopData(original: self.sectionOfShops.value[0], items: NetworkManager.shared.shopObs.value)
            sectionOfShops.accept([aNormalList])
        }else if self.filterView.filterType.text == sortOption {
            var sortFunc : SortFunction = { (ashop,bshop) in return true}
            if (self.filterView.filterValue.text ?? "") == byName {
                sortFunc = { (ashop,bshop) in
                    if ((ashop.shop_name ?? "") < (bshop.shop_name ?? "")) {return true}else{return false}
                }
            }else if (self.filterView.filterValue.text ?? "") == byRate {
                sortFunc = { (ashop,bshop) in
                    if ((Int(ashop.rate ?? "0") ?? 0) > (Int(bshop.rate ?? "0") ?? 0)) {return true}else{return false}
                }
            }else if (self.filterView.filterValue.text ?? "") == byOff {
                sortFunc = { (ashop,bshop) in
                    if ((ashop.shop_off ?? 0) > (bshop.shop_off ?? 0)) {return true}else{return false}
                }
            }else if (self.filterView.filterValue.text ?? "") == byFollower {
                sortFunc = { (ashop,bshop) in
                    if ((ashop.follower_count ?? 0) > (bshop.follower_count ?? 0)) {return true}else{return false}
                }
            }
            let aSortedData = SectionOfShopData(original: self.sectionOfShops.value[0], items: NetworkManager.shared.shopObs.value, sort: sortFunc)
            sectionOfShops.accept([aSortedData])
            
        }
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
        }else{
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
