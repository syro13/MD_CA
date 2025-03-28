//
//  Food.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import Foundation

struct Food: Identifiable{
    var id =  UUID()
    var item: String
    var emoji: String
}


let testData = [
    Food(item: "Chicken", emoji: "🐔"),
    Food(item: "Beef", emoji: "🐄"),
    Food(item: "Pork", emoji: "🐖")
]
