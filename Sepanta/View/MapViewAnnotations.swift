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
        let identifier = (annotation as? MapAnnotation)?.identifier ?? "MapAnnotation"
        var view: MKAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            view = dequeuedView
        } else {
            //view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        let annotationDim = UIScreen.main.bounds.width / 7
        let calloutDim = UIScreen.main.bounds.width / 10
        if identifier == "MapAnnotation" {
            view.canShowCallout = true
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: calloutDim, height: calloutDim))
            rightButton.setImage(UIImage(named: "MapArrow"), for: .normal)
            rightButton.setImage(UIImage(named: "MapArrow"), for: .application)
            rightButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            rightButton.backgroundColor = UIColor(hex: 0x515152)
            rightButton.tag = (annotation as! MapAnnotation).userId!
            rightButton.addTarget(self, action: #selector(pushShop), for: .touchUpInside)
            rightButton.layer.cornerRadius = 5
            view.rightCalloutAccessoryView = rightButton

            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: calloutDim, height: calloutDim))
            leftButton.setImage(UIImage(named: "car"), for: .normal)
            leftButton.setImage(UIImage(named: "car"), for: .application)
            leftButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            leftButton.backgroundColor = UIColor(hex: 0x515152)
            leftButton.tag = (annotation as! MapAnnotation).userId!
            leftButton.addTarget(self, action: #selector(openNavigationApps), for: .touchUpInside)
            leftButton.layer.cornerRadius = 5
            view.leftCalloutAccessoryView = leftButton

            view.calloutOffset = CGPoint(x: 0, y: 5)
            if let aMapAnnotation = (annotation as? MapAnnotation) {
                if aMapAnnotation.logo_map_image == nil {
                    view.image = UIImage(named: "map_pin_category")
                    let aSize = view.frame.size
                    let aScale = min(aSize.width/50, aSize.height/50)
                    view.frame.size = CGSize(width: aSize.width/aScale, height: aSize.height/aScale)
                } else {
                    if let logo_image = aMapAnnotation.logo_map_image {
                        view.image = logo_image
                        let aSize = view.frame.size
                        let aScale = min(aSize.width/50, aSize.height/50)
                        view.frame.size = CGSize(width: aSize.width/aScale, height: aSize.height/aScale)
                    } else {
                        view.image = UIImage(named: "map_pin_category")
                        let aSize = view.frame.size
                        let aScale = min(aSize.width/50, aSize.height/50)
                        view.frame.size = CGSize(width: aSize.width/aScale, height: aSize.height/aScale)
                    }

                    //view.image = resizeMapLogo(Image: aMapAnnotation.logo_map_image!)
                }
            }
        } else if  identifier ==  "SelectAnnotation" {
            view.canShowCallout = true
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: calloutDim, height: calloutDim))
            leftButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            leftButton.setImage(UIImage(named: "icon_tick_white"), for: .application)
            leftButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            leftButton.backgroundColor = UIColor(hex: 0x515152)
            leftButton.tag = (annotation as! MapAnnotation).userId!
            leftButton.addTarget(self, action: #selector(backOneLevel), for: .touchUpInside)
            leftButton.layer.cornerRadius = 5
            view.leftCalloutAccessoryView = leftButton
            view.calloutOffset = CGPoint(x: 0, y: 5)

/*            view.image = UIImage(named: "icon_place_black")
            view.frame = CGRect(x: 0, y: 0, width: annotationDim*14/19, height: annotationDim)
            view.contentMode = .scaleAspectFit
            view.image?.addShadow()
 */
            let mixedImage = CreateSelectPinPoint()
            view.image = mixedImage
        }
        return view
    }

    func resizeMapLogo(Image anUIImage: UIImage) -> UIImage {

        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        anUIImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return resizedImage
        } else {
            return CreateBallonImage(Image: UIImage(named: "icon_mainmenu_04")!)
        }
    }

    func CreateBallonImage(Image iconImage: UIImage) -> UIImage {

        let backgroundImage = UIImage(named: "icon_place_map")
        let annotationDim = UIScreen.main.bounds.width / 7
        let size = CGSize(width: annotationDim*14/19, height: annotationDim)
//        let size = CGSize(width: 35, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage?.draw(in: areaSize)
        let scale = (size.width/1.5)/max(iconImage.size.width, iconImage.size.height)
        let iconSize = CGRect(x: (size.width/2)-(iconImage.size.width*scale/2), y: (size.height/2)-(iconImage.size.height*scale/1.5), width: iconImage.size.width*scale, height: iconImage.size.height*scale)
        iconImage.draw(in: iconSize, blendMode: .normal, alpha: 1)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let shadowImage = newImage.addShadow()
        return shadowImage
    }

    func CreateSelectPinPoint() -> UIImage {

        let backgroundImage = UIImage(named: "icon_place_black")
        let annotationDim = UIScreen.main.bounds.width / 7
        let size = CGSize(width: annotationDim*14/19, height: annotationDim)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage?.draw(in: areaSize)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let shadowImage = newImage.addShadow(blurSize: 1)
        return shadowImage
    }

    @objc func backOneLevel(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }

    @objc func pushShop(_ sender: Any) {
        var tag: Int!
        var ashop: Shop!
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
        print("Pushing ", ashop)
        if ashop != nil {
            self.coordinator!.pushShop(Shop: ashop!)
        } else {
            alert(Message: "اطلاعات این فروشگاه تکمیل نیست،بزودی!!!")
        }
    }
}
