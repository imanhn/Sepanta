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

enum CardType {
    case Sepanta
    case Other
}

class PaymentViewController : UIViewControllerWithKeyboardNotificationWithErrorBar, Storyboarded, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
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
    var gatewayButton : GatewayButton?
    var withoutOffCost = BehaviorRelay(value: -1)
    var offValue = BehaviorRelay(value: -1)
    var cardId : String!
    var cardType : CardType!
    
    @IBAction func applyOffTapped(_ sender: Any) {
        if let anOffCode = offText.text {
            let checkOffCodeDisp = CheckOffCode(OffCode: anOffCode, CardId: cardId).results()
                .subscribe(onNext: {anOffCheckResult in
                    if let beforeOff = anOffCheckResult.amount_real {self.withoutOffCost.accept(beforeOff)}
                    if let offValue = anOffCheckResult.amount_discount {self.offValue.accept(offValue)}
                })
            checkOffCodeDisp.disposed(by: myDisposeBag)
            disposeList.append(checkOffCodeDisp)
        } else {
            self.alert(Message: "کد تخفیف وارد نشده است")
        }
    }
    
    @IBAction func payButtonTapped(_ sender: Any) {
        //self.alert(Message: selectedGateway?.name ?? "هیچی" + "انتخاب شد")
        let aDiscount : String = self.offText.text ?? ""
        let aServerBankLink = selectedGateway?.link
        let bankLinkDisp = GetBankLink(serverLink: aServerBankLink ?? "/api/v1/parsian", discountCode: aDiscount, cardId: cardId ?? "1").results()
            .subscribe(onNext: { [unowned self] aBankLink in
                // This is Shaparak (PSP) redirection
                if let shaparakLink = aBankLink.link_bank {
                    //self.coordinator?.pushPaymentWKWebView(WebAddress: shaparakLink)
                    self.coordinator?.pushPaymentUIWebView(WebAddress: shaparakLink)
                } else {
                    self.alert(Message: "خطایی در یافتن درگاه شاپرک اتفاق افتاد")
                }
            }, onError: {_ in })
        bankLinkDisp.disposed(by: myDisposeBag)
        disposeList.append(bankLinkDisp)
        
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
        /*
         _ = collectionView.rx.setDelegate(self)
         let selectCellDisp = collectionView.rx.itemSelected.subscribe(onNext: { anIndexPath in
         print("*** SELECT")
         let cell = self.collectionView.cellForItem(at: anIndexPath)
         cell?.layer.borderWidth = 2.0
         cell?.layer.borderColor = UIColor.gray.cgColor
         })
         selectCellDisp.disposed(by: myDisposeBag)
         disposeList.append(selectCellDisp)
         */

    }
    
    @objc func selectGateway(_ sender : Any) {
        // Select and Unselect the selected gateway button
        if gatewayButton != nil {
            gatewayButton!.layer.borderWidth = 0.0
            gatewayButton!.layer.borderColor = UIColor.white.cgColor
        }

        if let newGatewayButton = sender as? GatewayButton {
            gatewayButton = newGatewayButton
            selectedGateway = newGatewayButton.gateway
            gatewayButton!.layer.borderWidth = 2.0
            gatewayButton!.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / numberOfCellsInARow // compute your cell width
        //print("WOW Calling layout cell width : ",cellWidth," index : ",indexPath)
        //return CGSize(width: 50 , height: 50)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellSpacing : CGFloat = 10
        let cellWidth = (collectionView.bounds.width - 30) / numberOfCellsInARow
        let cellCount = collectionView.numberOfItems(inSection: 0)
        let totalCellwidth = CGFloat(cellCount) * cellWidth
        let cellSpace = CGFloat(cellCount - 1) * cellSpacing
        let spaceLeft = collectionView.bounds.width - totalCellwidth - cellSpace
        var inset = spaceLeft / 2
        inset = max(inset, 0.0)
        return UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: 0)
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
            .subscribe(onNext: { [unowned self] aPaymentGatewayList in
                print("self.cardType : \(self.cardType)")
                print("aPaymentGatewayList : \(aPaymentGatewayList)")
                if self.cardType == CardType.Sepanta {
                    print("Its a Sepanta card")
                    self.withoutOffCost.accept(aPaymentGatewayList.sepanta_card ?? 1800000)
                    self.offValue.accept(0)
                } else {
                    print("Its a Other card")
                    self.withoutOffCost.accept(aPaymentGatewayList.other_cards ?? 1500000)
                    self.offValue.accept(0)
                }
                
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
 
    func bindPaySummary() {
        let costUpdateDisp = Observable.zip(self.withoutOffCost, self.offValue, resultSelector: { [unowned self] (beforeCost, offVal) in
            print("Before : \(beforeCost) off : \(offVal)")
            self.withoutOffValueLabel.text = "\(beforeCost) ریال"
            self.totalAmountValueLabel.text = "\(beforeCost-offVal) ریال"
            self.offValueLabel.text = "\(offVal) ریال"
            self.offPercentValueLabel.text = "\(Int(100 * offVal / beforeCost)) درصد"
        }).subscribe()
        costUpdateDisp.disposed(by: myDisposeBag)
        disposeList.append(costUpdateDisp)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        self.collectionView.delegate = self
        self.collectionView.register(GatewayCell.self, forCellWithReuseIdentifier: "gatewayCellId")
        bindCollectionView()
        bindPaySummary()
    }
    
}
