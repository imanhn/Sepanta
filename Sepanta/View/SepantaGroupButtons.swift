//
//  SepantaGroupButtons.swift
//  Sepanta
//
//  Created by Iman on 12/5/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class SepantaGroupButtons {
    var delegate: SepantaGroupsViewController
    var counter = 0
    var myDisposeBag = DisposeBag()
    var buttons = [UIButton]()
    let xMargin = UIScreen.main.bounds.width / 20
    let buttonsDim = (UIScreen.main.bounds.width-2*(UIScreen.main.bounds.width / 20) ) / 3

    init(_ sepantaGroupViewController: SepantaGroupsViewController) {
        self.delegate = sepantaGroupViewController
        //createAllButtons()
    }

    @objc func aGroupTapped(_ sender: Any) {
        let theButton = (sender as AnyObject)
        //print("TAG : ",theButton.tag," delegate Coordinator : ",self.delegate.coordinator ?? "is Nil")
        let targetCatagory = self.getCatagory(ByID: theButton.tag!)
        let selectedCity = self.delegate.currentCityCodeObs.value//self.delegate.selectCity.text
        let selectedState = self.delegate.currentStateCodeObs.value//self.delegate.selectProvince.text
        print("State: ", self.delegate.selectedStateStr ?? "", "City: ", self.delegate.selectedCityStr ?? "")
        self.delegate.coordinator!.pushAGroup(GroupID: targetCatagory.id, GroupImage: targetCatagory.anUIImage.value, GroupName: targetCatagory.title, State: selectedState, City: selectedCity, StateStr: self.delegate.selectedStateStr, CityStr: self.delegate.selectedCityStr )
    }

    func getCatagory(ByID  anID: Int) -> Catagory {
        for aCat in self.delegate.catagories where aCat.id == anID {
            return aCat
        }
        return Catagory()
    }

    func updateScrollView(NumberOfIcons noOfIcons: Int) {
        let rows = Int(noOfIcons / 3)
        self.delegate.sepantaScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(rows+1)*buttonsDim*1.3)
    }
    func createButton(Row row: Int, Col col: Int, Tag tag: Int) {
        let but = UIButton(frame: CGRect(x: xMargin+CGFloat(col)*buttonsDim*0.9, y: CGFloat(row) * buttonsDim * 1.2, width: buttonsDim*1.3, height: buttonsDim*1.3))
        but.setImage(UIImage(named: "g\(tag)"), for: .normal)
        but.addTarget(self, action: #selector(aGroupTapped), for: .touchUpInside)
        but.tag = tag
        self.buttons.append(but)
        self.delegate.sepantaScrollView.addSubview(but)
    }

    func createGroups(Catagories catagories: [Catagory]) {
        let xMargin = UIScreen.main.bounds.width / 20
        let buttonsDim = (UIScreen.main.bounds.width-2*xMargin ) / 3
        updateScrollView(NumberOfIcons: catagories.count)
        for i in 0..<catagories.count {
            catagories[i].anUIImage
                .filter({$0.size.width > 0})
                .subscribe(onNext: { [unowned self] innerImage in
                    let foundButton = self.buttons.filter({$0.tag == catagories[i].id})
                    self.counter = i
                    if i >= 3 { self.counter += 1}
                    if i >= 14 { self.counter += 1}
                    let col = self.counter % 3
                    let row = Int(self.counter / 3)
                    let upsideDown : Bool = (col + (row * 3)) % 2 == 0
                    if foundButton.count == 0 {
                        //print(i," Addin image ",catagories[i].title)
                        let but = UIButton(frame: CGRect(x: xMargin+CGFloat(col)*buttonsDim*0.9, y: CGFloat(row) * buttonsDim * 1.2, width: buttonsDim*1.3, height: buttonsDim*1.3))
                        let mergedImage = self.buttonImage(Image: innerImage, Label: catagories[i].title, Up: upsideDown)
                        but.setImage(mergedImage, for: .normal)
                        but.tag = catagories[i].id
                        but.addTarget(self, action: #selector(self.aGroupTapped), for: .touchUpInside)
                        self.buttons.append(but)
                        self.delegate.sepantaScrollView.addSubview(but)
                    } else {
                        //print(i," Updating Image",catagories[i].title)
                        let mergedImage = self.buttonImage(Image: innerImage, Label: catagories[i].title, Up: upsideDown)
                        foundButton[0].setImage(mergedImage, for: .normal)
                    }
                    if self.counter == catagories.count-1 {Spinner.stop()}
                    //print("Image Received : ",self?.counter,"  ",catagories[i].title,"  ",catagories[i].id,"  ",catagories[i].image,"  ",innerImage)
                }, onError: { _ in

                }, onCompleted: {

                }, onDisposed: {

                }).disposed(by: myDisposeBag)
        }

    }

    func buttonImage(Image iconImage: UIImage, Label aLabel: String, Up upside: Bool) -> UIImage {

        var fontSize: CGFloat = 14
        if aLabel.count < 13 { fontSize = 14} else if aLabel.count < 15 {fontSize = 13} else if aLabel.count < 20 {fontSize = 12} else if aLabel.count < 25 {fontSize = 11} else {fontSize = 10}

        let textColor = UIColor(red: 0.31, green: 0.31, blue: 0.32, alpha: 1)
        let textFont = UIFont (name: "Shabnam FD", size: fontSize)!

        let backgroundImageDown = UIImage(named: "btn_down")
        let backgroundImageUp = UIImage(named: "btn_up")

        let size = CGSize(width: buttonsDim*1.3, height: buttonsDim*1.3)
        //UIGraphicsBeginImageContext(size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        var textBox = CGRect()
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //print("upside : ",upside)
        if upside {
            backgroundImageDown?.draw(in: areaSize)
            textBox = CGRect(x: 0, y: 0, width: size.width, height: size.height/2)
        } else {
            backgroundImageUp?.draw(in: areaSize)
            textBox = CGRect(x: 0, y: size.height/2, width: size.width, height: size.height/2)
        }
        let scale = (size.width/3.33)/max(iconImage.size.width, iconImage.size.height)
        let iconSize = CGRect(x: (size.width/2)-(iconImage.size.width*scale/2), y: (size.height/2)-(iconImage.size.height*scale/2), width: iconImage.size.width*scale, height: iconImage.size.height*scale)
        iconImage.draw(in: iconSize, blendMode: .normal, alpha: 1)

//        NSString(string: aLabel).draw(in: textBox, withAttributes: textFontAttributes)
        let lab = UILabel(frame: textBox)
        lab.text = aLabel
        lab.font = textFont
        lab.textColor = textColor
        lab.textAlignment = .center
        lab.adjustsFontSizeToFitWidth = true

        lab.drawText(in: textBox)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
