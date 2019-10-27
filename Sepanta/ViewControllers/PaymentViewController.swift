//
//  PaymentViewController.swift
//  Sepanta
//
//  Created by Iman on 8/4/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

class GatewayCell: UICollectionViewCell {
    
    var aButton: GatewayButton = GatewayButton(type: .custom)
}

class PaymentViewController : UIViewControllerWithKeyboardNotificationWithErrorBar, Storyboarded, UICollectionViewDelegateFlowLayout {
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    let numberOfCellsInARow : CGFloat = 4
    weak var coordinator: HomeCoordinator?
    var gatewayListObs = BehaviorRelay(value: [PaymentGateway]())
    @IBOutlet weak var offText: UITextField!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var withoutOffValueLabel: UILabel!
    @IBOutlet weak var offValueLabel: UILabel!
    @IBOutlet weak var offPercentValueLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var applyOffButton: UIButton!
    var selectedGateway : PaymentGateway?
    
    @IBAction func applyOffTapped(_ sender: Any) {
    }
    
    @IBAction func payButtonTapped(_ sender: Any) {
        self.alert(Message: selectedGateway?.name ?? "هیچی" + "انتخاب شد")
    }
    
    func bindCollectionView() {
        let gatewayCollectionViewDisp = gatewayListObs.bind(to: collectionView.rx.items(cellIdentifier: "gatewayCellId")) { [weak self] _, model, cell in
            if let aCell = cell as? GatewayCell {
                //if aCell.aButton == nil {aCell.aButton = UIButton(type: .custom)}
                let strURL = NetworkManager.shared.websiteRootAddress  + model.logo!
                let imageURL = URL(string: strURL)
                let dim = ((self?.collectionView.bounds.width ?? 50) * 0.8) / (self?.numberOfCellsInARow ?? 4)
                //print("ROW:\(row) UICollectionView binding : ",imageURL ?? "NIL"," Cell : ",aCell,"  model : ",model)
                //print("ShopUI Binding Posts : ",model)
                //self?.collectionView.addSubview(aCell)
                aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                aCell.addSubview(aCell.aButton)
                if imageURL == nil {
                    //print("     Post URL is not valid : ",model.image)
                    aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                } else {
                    //aCell.aButton.af_setImage(for: .normal, url: imageURL!) //Also Works!
                    aCell.aButton.setImageFromCache(PlaceHolderName: "bank-building", Scale: 1, ImageURL: imageURL!, ImageName: model.logo!)
                }
                aCell.aButton.layer.shadowColor = UIColor.black.cgColor
                aCell.aButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                aCell.aButton.layer.shadowRadius = 2
                aCell.aButton.layer.shadowOpacity = 0.2
                aCell.aButton.gateway = model
                aCell.aButton.addTarget(self, action: #selector(self?.selectGateway), for: .touchUpInside)
            } else {
                print("\(cell) can not be casted to ButtonCell")
            }
        }
        gatewayCollectionViewDisp.disposed(by: myDisposeBag)
        disposeList.append(gatewayCollectionViewDisp)
        
    }
    
    @objc func selectGateway(_ sender : Any) {
        if let gatewayButton = sender as? GatewayButton {
            selectedGateway = gatewayButton.gateway
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / numberOfCellsInARow // compute your cell width
        //print("WOW Calling layout cell width : ",cellWidth," index : ",indexPath)
        //return CGSize(width: 50 , height: 50)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    
    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }
    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
    }
    
    func getGatewayList() {
        let paymentCallDisp = GetPaymentGatewayList().results()
            .subscribe(onNext: { aPaymentGatewayList in
                if let gateways = aPaymentGatewayList.link {
                    self.gatewayListObs.accept(gateways)
                }
            } , onError: {_ in })
        paymentCallDisp.disposed(by: myDisposeBag)
        disposeList.append(paymentCallDisp)

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGatewayList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        self.collectionView.delegate = self
        self.collectionView.register(GatewayCell.self, forCellWithReuseIdentifier: "gatewayCellId")
        bindCollectionView()
    }
    
}
