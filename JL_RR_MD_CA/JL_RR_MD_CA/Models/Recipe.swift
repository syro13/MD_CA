//
//  Recipe.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 18/04/25.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let image: String
    let usedIngredients: [Ingredient]
    let missedIngredients: [Ingredient]
}


