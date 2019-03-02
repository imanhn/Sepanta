//
//  MenuItems.swift
//  Sepanta
//
//  Created by Iman on 12/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

//
// MARK: - Section Data Structure
//
public struct Item {
    var name: String
    var detail: String
    
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}

public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section] = [
    Section(name: "Data Exchange", items: [
        Item(name: "WebService Address", detail: "Address to send acquired data."),
        Item(name: "Data Format", detail: "GML/GeoJSON/KMZ/KML/CSV"),
        Item(name: "Send Method", detail: "Online/Offline"),
        ]),
    Section(name: "Smallworld Map Server", items: [
        Item(name: "WMS Settings", detail: "GSS Map Server Setting"),
        Item(name: "SIAS Integration", detail: "SIAS Address/Authorization"),
        ]),
    
    Section(name: "Layers", items: [
        Item(name: "Google Map", detail: "Selects Google-Map as background map"),
        Item(name: "OpenStreet Map", detail: "Select OSM as background map"),
        Item(name: "GE Smallworld", detail: "Use Smallworld Map"),
        ]),
    Section(name: "Miscellaneous", items: [
        Item(name: "About US", detail: "Written by Iman H. Nia"),
        Item(name: "About This App", detail: "Pilot project to integrate Smallworld to iOS devices"),
        Item(name: "Help", detail: "Help about this application"),
        Item(name: "Sign in", detail: "Sign-in to get your predefined settings.")
        ])
]
