//
//  ShopListViewControllerProtocol.swift
//  Sepanta
//
//  Created by Iman on 1/9/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ShopListViewControllerProtocol {
    var shops: BehaviorRelay<[Shop]> {get set}
}
