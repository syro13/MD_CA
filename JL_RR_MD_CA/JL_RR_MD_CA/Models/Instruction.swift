//
//  Instruction.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 19/04/25.
//

import Foundation

struct Instruction: Decodable {
    let steps: [Step]
}

struct Step: Decodable {
    let number: Int
    let step: String
}

