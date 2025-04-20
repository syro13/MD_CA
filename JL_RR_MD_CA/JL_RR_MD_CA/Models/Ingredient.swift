//
//  Ingredient.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 19/04/25.
//

import Foundation

struct Ingredient: Identifiable, Decodable {
    let id: Int
    let name: String
    let original: String
    let image: String
}

