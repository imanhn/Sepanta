//
//  NearestViewController.swift
//  Sepanta
//
//  Created by Iman on 2/2/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import MapKit
import CoreLocation

enum MapType {
    case NearbyShops
    case SingleShop
    case GroupOfShops
    case selectOnMap
}

class NearestViewController: UIViewControllerWithErrorBar, XIBView, CLLocationManagerDelegate {
    weak var coordinator: HomeCoordinator?
    var myDisposeBag = DisposeBag()
    var aPinPointAnnotation: MapAnnotation!
    var pinPointName: String!
    var locationManager: CLLocationManager!
    var destinationCRD: CLLocationCoordinate2D!
    var annotations = [Int : MKAnnotation]()
    var installedNavigationApps = ["Apple Maps": ""]
    //var myLocation = CLLocation(latitude: 35.755985, longitude: 51.546742)
    var myLocation: CLLocation?
    var oldLocation: CLLocation?
    let regionRadius: CLLocationDistance = 1000
    var mapMode: MapType!
    var shopToShow: Shop!
    var shopDisposable: Disposable!

    @IBOutlet weak var gotoMyLocation: UIButton!

    @IBOutlet weak var mapView: MKMapView!

    @IBAction func menuTapped(_ sender: Any) {
        self.coordinator!.openButtomMenu()
    }

    @objc override func willPop() {
        NetworkManager.shared.shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
        locationManager.stopUpdatingLocation()
        if shopDisposable != nil {
            shopDisposable.dispose()
        }
    }

    @IBAction func BackTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }

    @IBAction func gotoMyLocationTapped(_ sender: Any) {
        centerMapOnLocation(Coordinate: myLocation?.coordinate)
    }

    @IBAction func BackToHome(_ sender: Any) {
        self.coordinator!.popHome()
    }
    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func centerMapOnLocation(Coordinate coordinate: CLLocationCoordinate2D?) {
        guard coordinate != nil else {
            print("No location for now!")
            return
        }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate!,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = manager.location!
        if oldLocation == nil || (oldLocation!.distance(from: myLocation!) > Double(1000)) {
            if mapMode == MapType.NearbyShops {
                centerMapOnLocation(Coordinate: myLocation?.coordinate)
                getNearByShops()
            }
            if  mapMode == MapType.selectOnMap {
                centerMapOnLocation(Coordinate: myLocation?.coordinate)
            }
            oldLocation = myLocation!
        }
    }

    func getShopCoord(FromTag tag: Int) {

    }
    @objc func openNavigationApps(_ sender: UIButton) {
        guard myLocation != nil else {
            alert(Message: "موقعیت شما معلوم نیست احتمالا جی پی اس شما خاموش است")
            return
        }
        guard annotations[sender.tag] != nil else {
            alert(Message: "متاسفانه مشکلی پیش آمده است")
            print("TAG : ", sender.tag)
            print("Annotations : ", annotations)
            return
        }

        destinationCRD = annotations[sender.tag]!.coordinate

        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            print("WAZE INSTALLED!")
        }
        let alert = UIAlertController(title: "مسیریابی", message: "مسیریاب خود را انتخاب کنید", preferredStyle: .actionSheet)

        let button = UIAlertAction(title: "Apple Map", style: .default, handler: { _ in
            self.openAppleMap()
        })
        alert.addAction(button)

        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            //Google Exists
            let button = UIAlertAction(title: "Google Map", style: .default, handler: { _ in
                self.openGoogleMap()
            })
            alert.addAction(button)
        }
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            //waze Exists
            let button = UIAlertAction(title: "Waze", style: .default, handler: {_ in
                self.openWaze()
            })
            alert.addAction(button)
        }
        let cancelButton = UIAlertAction(title: "منصرف شدم", style: .default, handler: {_ in
                alert.dismiss(animated: true, completion: {})
            })
        alert.addAction(cancelButton)

        self.present(alert, animated: true, completion: nil)
    }

    func openWaze() {
        let urlStr: String = "waze://?ll=\(destinationCRD.latitude),\(destinationCRD.longitude)&navigate=yes"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
    }

    func openGoogleMap() {
        UIApplication.shared.open(URL(string:
            "comgooglemaps://?saddr=&daddr=\(destinationCRD.latitude),\(destinationCRD.longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
    }

    func openAppleMap() {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: myLocation!.coordinate))
        source.name = "Source"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCRD!))
        destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    func getNearByShops() {
        guard myLocation != nil else {
            print("No location, Nothing fetched!")
            return
        }
        //print("MyLocation : ", myLocation)
        let userLat = myLocation!.coordinate.latitude
        let userLon = myLocation!.coordinate.longitude
        let aParameter = ["lat": "\(userLat)",
                          "long": "\(userLon)"]
        NetworkManager.shared.run(API: "shops-location", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)

        shopDisposable = NetworkManager.shared.shopObs
            .subscribe(onNext: { shops in
                for ashop in shops {
                    if let aLat = ashop.lat,
                        let aLon = ashop.lon {
                        let adist = sqrt( pow(aLat - userLat,2) + pow(aLon - userLon,2))
                        if adist > 0.03 {continue}
                    }
                    let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_category_logo_map + (ashop.shop_logo_map ?? "sepanta.png")
                    print("imageUrl  \(imageUrl)")
                    print("ashop : \(ashop)")
                    Alamofire.request(imageUrl).responseImage { [unowned self] response in
                        if let image = response.result.value {
                            //print("image downloaded: \(imageUrl)")
                            let aShopAnnotation = MapAnnotation(WithShop: ashop,Logo: image)
                            self.annotations[ashop.user_id!] = aShopAnnotation
                            self.mapView.addAnnotation(aShopAnnotation)
                        }
                    }
                }
            })
        shopDisposable.disposed(by: myDisposeBag)
    }

    func buildUI() {
        gotoMyLocation.layer.cornerRadius = gotoMyLocation.frame.width/2
        gotoMyLocation.backgroundColor = UIColor(hex: 0xF7F7F7)
        gotoMyLocation.layer.shadowColor = UIColor.black.cgColor
        gotoMyLocation.layer.shadowOffset = CGSize(width: 3, height: 3)
        gotoMyLocation.layer.shadowRadius = 3
        gotoMyLocation.layer.shadowOpacity = 0.3
    }

    func showSingleShop() {
        //print("shopToShow  : \(shopToShow)")
        mapView.removeAnnotations(mapView.annotations)
        if shopToShow != nil {
            let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_category_logo_map + (shopToShow.shop_logo_map ?? "sepanta.png")
            Alamofire.request(imageUrl).responseImage { [unowned self] response in
                if let image = response.result.value {
                    //print("image downloaded: \(imageUrl)")
                    let aShopAnnotation = MapAnnotation(WithShop: self.shopToShow,Logo: image)
                    self.annotations[self.shopToShow.user_id!] = aShopAnnotation
                    self.mapView.addAnnotation(aShopAnnotation)
                    self.centerMapOnLocation(Coordinate: aShopAnnotation.coordinate)
                }
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        initLocationManager()
        mapView.delegate = self
        mapView.showsUserLocation = true
        print("mapMode : ", mapMode)
        switch mapMode {
        case MapType.NearbyShops?:
            //print("Showing nearby Shops")
            getNearByShops()
            if myLocation != nil {
                centerMapOnLocation(Coordinate: myLocation!.coordinate)
            }
        case MapType.selectOnMap?:
            print("*** Select On  Map")
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation))
            longPress.minimumPressDuration = 0.5
            self.mapView.addGestureRecognizer(longPress)
            if myLocation != nil {
                centerMapOnLocation(Coordinate: myLocation!.coordinate)
            }
        case MapType.SingleShop?:
            //print("Showing single shop")
            showSingleShop()
        default:
            print("Default Mode...")
            //getNearByShops()
        }
    }
    @objc func selectLocation(_ agesture: UILongPressGestureRecognizer) {
        print("State : ", agesture)
        if agesture.state == .ended || agesture.state == .began {
            let locationInView = agesture.location(in: self.mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            //addAnnotation(location: locationOnMap)
            print("LOCA : ", locationOnMap)
            if aPinPointAnnotation != nil {
                self.mapView.removeAnnotation(aPinPointAnnotation)
            }
            aPinPointAnnotation = MapAnnotation(title: self.pinPointName ?? "فروشگاه جدید", locationName: self.pinPointName ?? "فروشگاه جدید", coordinate: locationOnMap, identifier: "SelectAnnotation")
            self.mapView.addAnnotation(aPinPointAnnotation)
            NetworkManager.shared.selectedLocation.accept(locationOnMap)
        }

    }
}
