//
//  PaymentUIWebViewController.swift
//  Sepanta
//
//  Created by Iman on 8/6/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//


import Foundation
import WebKit

class PaymentUIWebViewController : UIViewControllerWithErrorBar,UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    
    var webAddress : String!
    weak var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadWebView()
    }
    
    func loadWebView() {
        if webAddress != nil {
            if let aUrl = URL(string:webAddress ?? "www.sepantaclubs.ir") {
                let urlRequest = URLRequest(url: aUrl)
                webView.loadRequest(urlRequest)
            }
        }
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("request: \(request.description)")
        if request.description.contains("CancelPayment") {
            self.coordinator?.popOneLevel(Message: "شما از پرداخت انصراف دادید")
            return false
        }
        if request.description.contains("status=0") {
            //do close window magic here!!
            print("status : ",request.description)
            self.coordinator?.popOneLevel(Message: "پرداخت انجام نشد")
            return false
        }
        if request.description.contains("status=1") {
            //do close window magic here!!
            print("status : ",request.description)
            self.coordinator?.popHome(Message: "عملیات پرداخت با موفقیت انجام شد")
            return false
        }

        return true
    }
    
    func stopLoading() {
        self.coordinator?.popOneLevel(Message: "شما از پرداخت انصراف دادید")
    }
}
