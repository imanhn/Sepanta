//
//  SepantaGroupButtons.swift
//  Sepanta
//
//  Created by Iman on 12/5/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
class SepantaGroupButtons {
    var delegate : SepantaGroupsViewController
    var buttons = [UIButton]()
    let xMargin = UIScreen.main.bounds.width / 20
    let buttonsDim = (UIScreen.main.bounds.width-2*(UIScreen.main.bounds.width / 20) ) / 3

    init(_ sepantaGroupViewController : SepantaGroupsViewController) {
        self.delegate = sepantaGroupViewController
        let rows = 7
        self.delegate.sepantaScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(rows+1)*buttonsDim*1.3)
        createAllButtons()
    }
    @objc func aGroupTapped(_ sender: Any){
        let theButton = (sender as AnyObject)
        print("TAG : ",theButton.tag)
        
    }
    
    func createButton(Row row : Int,Col col : Int,Tag tag : Int){
        let but = UIButton(frame: CGRect(x: xMargin+CGFloat(col)*buttonsDim*0.9, y: CGFloat(row) * buttonsDim * 1.2, width: buttonsDim*1.3, height: buttonsDim*1.3))
        but.setImage(UIImage(named: "g\(tag)"), for: .normal)
        but.addTarget(self, action: #selector(aGroupTapped), for: .touchUpInside)
        but.tag = tag
        self.buttons.append(but)
        self.delegate.sepantaScrollView.addSubview(but)
    }
    
    func createAllButtons(){
        createButton(Row: 0, Col: 0, Tag: 3)
        createButton(Row: 0, Col: 1, Tag: 2)
        createButton(Row: 0, Col: 2, Tag: 1)
        
        //createButton(Row: 1, Col: 0, Tag: 0)
        createButton(Row: 1, Col: 1, Tag: 5)
        createButton(Row: 1, Col: 2, Tag: 4)
        
        createButton(Row: 2, Col: 0, Tag: 8)
        createButton(Row: 2, Col: 1, Tag: 7)
        createButton(Row: 2, Col: 2, Tag: 6)
        
        createButton(Row: 3, Col: 0, Tag: 11)
        createButton(Row: 3, Col: 1, Tag: 10)
        createButton(Row: 3, Col: 2, Tag: 9)
        
        createButton(Row: 4, Col: 0, Tag: 14)
        createButton(Row: 4, Col: 1, Tag: 13)
        createButton(Row: 4, Col: 2, Tag: 12)
        
        //createButton(Row: 5, Col: 0, Tag: 0)
        createButton(Row: 5, Col: 1, Tag: 16)
        createButton(Row: 5, Col: 2, Tag: 15)
        
        createButton(Row: 6, Col: 0, Tag: 18)
        createButton(Row: 6, Col: 1, Tag: 17)
        //createButton(Row: 6, Col: 2, Tag: 0)
        

    }
}
