//
//  Product.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 20/04/25.
//


import Foundation

struct Product: Codable {
    let name: String
    let emoji: String
}

class ProductLookup {
    static func loadProducts() -> [String: Product] {
        guard let url = Bundle.main.url(forResource: "ProductCatalog", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let rawDict = plist as? [String: [String: String]] else {
            return [:]
        }

        var result: [String: Product] = [:]
        for (barcode, details) in rawDict {
            if let name = details["name"], let emoji = details["emoji"] {
                result[barcode] = Product(name: name, emoji: emoji)
            }
        }

        return result
    }
}
