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
}

class NearestViewController : UIViewControllerWithErrorBar,XIBView,CLLocationManagerDelegate {
    weak var coordinator : HomeCoordinator?
    var myDisposeBag = DisposeBag()
    var locationManager:CLLocationManager!
    var myLocation = CLLocation(latitude: 35.755985, longitude: 51.546742)
    let regionRadius: CLLocationDistance = 2000
    var mapMode : MapType!
    var shopToShow : Shop!
    var shopDisposable : Disposable!
    
    @IBOutlet weak var gotoMyLocation: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func menuTapped(_ sender: Any) {
        self.coordinator!.openButtomMenu()
    }
    
    @IBAction func BackTapped(_ sender: Any) {
        NetworkManager.shared.shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
        locationManager.stopUpdatingLocation()
        //mapView.removeAnnotations(mapView.annotations)
        if shopDisposable != nil {
            shopDisposable.dispose()
        }
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func gotoMyLocationTapped(_ sender: Any) {
        centerMapOnLocation(Coordinate: myLocation.coordinate)
    }
    
    @IBAction func BackToHome(_ sender: Any) {
        NetworkManager.shared.shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
        self.coordinator!.popHome()
    }
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func centerMapOnLocation(Coordinate coordinate : CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = manager.location!
    }
    

    
    func getNearByShops(){
        let aParameter = ["lat":"\(myLocation.coordinate.latitude)",
                          "long":"\(myLocation.coordinate.longitude)"]
        NetworkManager.shared.run(API: "shops-location", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
        
        shopDisposable = NetworkManager.shared.shopObs
            .subscribe(onNext: { shops in
                for ashop in shops
                {
                    //print("ADDING ",(ashop as! Shop).user_id)
                    //let aShopAnnotation = ShopAnnotation(WithShop: ashop as! Shop)
                    let aShopAnnotation = MapAnnotation(WithShop: ashop)
                    self.mapView.addAnnotation(aShopAnnotation)
                    
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
    
    func showSingleShop(){
        //print("Single Mode : ",shopToShow)
        mapView.removeAnnotations(mapView.annotations)
        if shopToShow != nil {
            let aShopAnnotation = MapAnnotation(WithShop: shopToShow!)
            self.mapView.addAnnotation(aShopAnnotation)
            //print("Adding label : ",aShopAnnotation.coordinate)
            centerMapOnLocation(Coordinate: aShopAnnotation.coordinate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        buildUI()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        initLocationManager()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        switch mapMode {
        case MapType.NearbyShops?:
            //print("Showing nearby Shops")
            getNearByShops()
            centerMapOnLocation(Coordinate: myLocation.coordinate)
            break
        case MapType.SingleShop?:
            //print("Showing single shop")
            showSingleShop()
            break
        default:
            print("Default Mode...")
            //getNearByShops()
        }
    }
}
