//
//  PaymentWKWebView.swift
//  Sepanta
//
//  Created by Iman on 8/5/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import WebKit

class PaymentWKWebViewController : UIViewControllerWithErrorBar,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    
    @IBOutlet weak var webView: WKWebView!
    var webAddress : String!
    weak var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadWebView()
        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")
        contentController.add(self, name: "bankresult")
        webView.configuration.userContentController = contentController

    }
    
    func loadWebView() {
        if webAddress != nil {
            if let aUrl = URL(string:webAddress ?? "www.sepantaclubs.ir") {
                let urlRequest = URLRequest(url: aUrl)
                webView.load(urlRequest)
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Message name : \(message.name)")
        print("Message body : \(message.body)")
        print("Message frameInfo : \(message.frameInfo)")
        guard let response = message.body as? String else { return }
        print("Response : \(response)")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("Redirect : navigation.description: \(navigation.description)")
        if navigation.description.contains("bankresult") {
            //do close window magic here!!
            print("url matches...")
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("HASH : \(navigation.hashValue)")
        print("Finished : navigation.description: \(navigation.description)")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("request: \(request.description)")
        if request.description.contains("bankresult") {
            //do close window magic here!!
            print("url matches...")
            return false
        }
        return true
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation: \(navigation.debugDescription)")
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("Terminated")
    }

    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        print("Peek action \(elementInfo)")
        return self
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Did commit : \(navigation.debugDescription) AND \(navigation.description)")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed \(navigation.description)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("FAILED provisional ")
        print("navigation : \(navigation.description)   error \(error)")
        let aUrlKey = (error as NSError).userInfo["NSErrorFailingURLKey"]
        print("aUrlKey : ",aUrlKey.debugDescription)
        print("aUrlKey.debugDescription : ",aUrlKey.debugDescription)
        if let aStatusStr = aUrlKey.debugDescription.split(separator: "?").last {
            print("aStatusStr : ",aStatusStr)
            if let statusCodeStr = aStatusStr.split(separator: "=").last {
                print("BANK RESULT : \(statusCodeStr)")
                if (statusCodeStr == "0)") {
                    self.coordinator?.popOneLevel(Message: "شما از پرداخت انصراف دادید")
                }
            }
        }
    }
}
