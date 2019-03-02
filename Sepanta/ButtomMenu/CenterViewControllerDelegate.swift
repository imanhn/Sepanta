//
//  CenterViewControllerDelegate.swift
//  Sepanta
//
//  Created by Iman on 12/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}
