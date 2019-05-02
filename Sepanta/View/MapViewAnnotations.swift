//
//  MapAnnotations.swift
//  Sepanta
//
//  Created by Iman on 2/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import MapKit
extension NearestViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //print("MapVIEW Mathod is called!")
        //guard let annotation = annotation as? ShopAnnotation else { return nil }
        // 3
        if annotation is MKUserLocation { return nil}
        let identifier = "MapAnnotation"
        var view: MKAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            view = dequeuedView
        } else {
            //view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        view.canShowCallout = true
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setImage(UIImage(named: "MapArrow"), for: .normal)
        rightButton.setImage(UIImage(named: "MapArrow"), for: .application)
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        rightButton.backgroundColor = UIColor(hex: 0x515152)
        
        rightButton.tag = (annotation as! MapAnnotation).userId!
        rightButton.addTarget(self, action: #selector(pushShop), for: .touchUpInside)
        //print("rightButton.tag : ",rightButton.tag)
        rightButton.layer.cornerRadius = 5
        view.rightCalloutAccessoryView = rightButton
        view.calloutOffset = CGPoint(x: 0, y: 5)
        let mixedImage = CreateBallonImage(Image: UIImage(named: "icon_mainmenu_04")!)
        view.image = mixedImage
        return view
    }
    
    func CreateBallonImage(Image iconImage : UIImage)->UIImage{
        
        let backgroundImage = UIImage(named: "icon_place_map")
        
        let size = CGSize(width: 35, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage?.draw(in: areaSize)
        let scale = (size.width/1.5)/max(iconImage.size.width,iconImage.size.height)
        let iconSize = CGRect(x: (size.width/2)-(iconImage.size.width*scale/2), y: (size.height/2)-(iconImage.size.height*scale/1.5), width: iconImage.size.width*scale, height: iconImage.size.height*scale)
        iconImage.draw(in: iconSize, blendMode: .normal, alpha: 1)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let shadowImage = newImage.addShadow()
        return shadowImage
    }
    
    @objc func pushShop(_ sender : Any){
        var tag : Int!
        var ashop : Shop!
        if let rightButton = sender as? UIButton {
            tag = rightButton.tag
        }
        if tag == nil {
            print("MapAnnotation [rightbutton] does not have a Tag,it is Nil!")
            return
        }
        
        for anAnnotation in mapView.annotations {
            if let castedAnnotation = anAnnotation as? MapAnnotation {
                if castedAnnotation.userId == (sender as! UIButton).tag {
                    ashop = castedAnnotation.shop
                }
            }
        }
        if ashop == nil {
            print("MapAnnotation does not have a Shop,it is Nil!")
            return
        }
        print("Pushing ",ashop)
        if ashop != nil {
            self.coordinator!.pushShop(Shop: ashop!)
        }else{
            alert(Message: "اطلاعات این فروشگاه تکمیل نیست،بزودی!!!")
        }
    }
}
