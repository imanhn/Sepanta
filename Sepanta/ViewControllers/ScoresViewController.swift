//
//  ScoresViewController.swift
//  Sepanta
//
//  Created by Iman on 2/11/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ScoreCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
}

class ScoresViewController: UIViewControllerWithErrorBar, XIBView, UITableViewDelegate {
    @IBOutlet weak var ScoreTableView: UITableView!
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    var userPointsElementsObs = BehaviorRelay<[PointElement]>(value: [PointElement]())
    var totalPoint : Int!
    weak var coordinator: HomeCoordinator?
    @IBOutlet weak var totalNumLabel: UILabel!

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

    func bindScores() {
        let scoreDisposable = userPointsElementsObs.bind(to: ScoreTableView!.rx.items(cellIdentifier: "ScoreCell")) { _, aScore, cell in
            if let aCell = cell as? ScoreCell {
                let model = aScore
                aCell.titleLabel.text = model.key ?? ""
                aCell.scoreLabel.text = "\(model.total ?? 0)"
                self.ScoreTableView.rowHeight = UIScreen.main.bounds.height/9
            }
        }
        scoreDisposable.disposed(by: myDisposeBag)
        disposeList.append(scoreDisposable)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        totalNumLabel.text = "\(totalPoint ?? 0)"
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindScores()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print("View DID Disapear!")
    }

}
