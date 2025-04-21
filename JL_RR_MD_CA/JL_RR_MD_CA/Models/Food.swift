//
//  Food.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import Foundation

struct Food: Identifiable, Codable, Equatable {
    var id = UUID()
    var item: String
    var emoji: String
    var expires: Date
}

func parseDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.date(from: string) ?? Date()
}

let testData = [
    Food(item: "Chicken", emoji: "🐔", expires: parseDate("10/04/2025")),
    Food(item: "Beef", emoji: "🐄", expires: parseDate("15/04/2025")),
    Food(item: "Pork", emoji: "🐖", expires: parseDate("20/04/2025")),
    Food(item: "Bread", emoji: "🍞", expires: parseDate("05/04/2025"))
]
