//
//  ArrayChoiceTableViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import UIKit

class ArrayChoiceTableViewController<Element>: UITableViewController {

    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    fileprivate var values: [Element]
    fileprivate var labels: LabelProvider
    fileprivate var onSelect: SelectionHandler?

    init(_ values: [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect: SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
        super.init(style: .plain)
    }
    init() {
        self.values = [Element]()
        self.labels = {(element) -> (String) in
            return ""
        }
        self.onSelect = {(element) -> Void in
        }
        super.init(style: .plain)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    func update(_ values: [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect: SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = labels(values[indexPath.row])
        cell.textLabel?.font = UIFont (name: "Shabnam FD", size: 16)
        cell.textLabel?.textAlignment = .right
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        onSelect?(values[indexPath.row])
    }

}

class MenuLister<Element>: ArrayChoiceTableViewController<Element> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0x515152)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(hex: 0x515152)
        cell.textLabel?.text = labels(values[indexPath.row])
        cell.textLabel?.font = UIFont (name: "Shabnam FD", size: 13)
        cell.textLabel?.backgroundColor = UIColor(hex: 0x515152)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .right
        //tableView.backgroundColor = UIColor(hex: 0x515152)
        return cell
    }
}
