//
//  ContactUSEmoji.swift
//  Sepanta
//
//  Created by Iman on 2/10/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
extension ContactUSViewController {
    @IBAction func goodTapped(_ sender: Any) {
        if goodButton.tag == 0 {
            goodButton.tag = 1
            notBadButton.tag = 0
            badButton.tag = 0
        }
        updateEmojis(updateServer: true)
    }
    @IBAction func notBadTapped(_ sender: Any) {
        if notBadButton.tag == 0 {
            goodButton.tag = 0
            notBadButton.tag = 1
            badButton.tag = 0
        }
        updateEmojis(updateServer: true)
    }
    @IBAction func badTapped(_ sender: Any) {
        if badButton.tag == 0 {
            goodButton.tag = 0
            notBadButton.tag = 0
            badButton.tag = 1
        }
        updateEmojis(updateServer: true)
    }

    func updateEmojis(updateServer: Bool) {
        if goodButton.tag == 1 { goodButton.setImage(UIImage(named: "icon_emoji_01_color"), for: .normal) } else { goodButton.setImage(UIImage(named: "icon_emoji_01"), for: .normal) }
        if notBadButton.tag == 1 { notBadButton.setImage(UIImage(named: "icon_emoji_02_color"), for: .normal) } else { notBadButton.setImage(UIImage(named: "icon_emoji_02"), for: .normal) }
        if badButton.tag == 1 { badButton.setImage(UIImage(named: "icon_emoji_03_color"), for: .normal) } else { badButton.setImage(UIImage(named: "icon_emoji_03"), for: .normal) }
        if updateServer == true {
            sendPollToServer()
        }
    }

    func getPollFromServer() {
        NetworkManager.shared.run(API: "poll", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
        NetworkManager.shared.pollObs
            .subscribe(onNext: { [unowned self] aPollNo in
                self.goodButton.tag = 0
                self.notBadButton.tag = 0
                self.badButton.tag = 0
                if aPollNo == 1 {
                    self.badButton.tag = 1
                } else if aPollNo == 2 {
                    self.notBadButton.tag = 1
                } else if aPollNo == 3 {
                    self.goodButton.tag = 1
                }
                self.updateEmojis(updateServer: false)
            }).disposed(by: myDisposeBag)
    }
    func sendPollToServer() {
        var pollNo = 0
        if goodButton.tag == 1 {pollNo = 3} else if notBadButton.tag == 1 {pollNo = 2} else if badButton.tag == 1 {pollNo = 1}
        let aParameter = ["poll": "\(pollNo)"]
        NetworkManager.shared.run(API: "poll", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
    }
}
