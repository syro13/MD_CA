//
//  Food_Card.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct Food_Card: View {
    let foods: [Food] = testData
    var expiringSoon: [Food] {
        foods.filter { Calendar.current.isDate($0.expires, inSameDayAs: Date()) || $0.expires <= Calendar.current.date(byAdding: .day, value: 2, to: Date())! }
    }

    var notExpiringSoon: [Food] {
        foods.filter { !expiringSoon.contains($0) }
    }
    var body: some View {
        VStack(alignment: .leading) {
            if !expiringSoon.isEmpty {
                Text("⚠️ Expiring Soon")
                    .font(.headline)
                    .padding(.leading)

                ForEach(expiringSoon) { food in
                    foodRow(for: food)
                }
            }

            if !notExpiringSoon.isEmpty {
                Text("All Items")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top)

                ForEach(notExpiringSoon) { food in
                    foodRow(for: food)
                }
            }
        }
    }
}
@ViewBuilder
func foodRow(for food: Food) -> some View {
    HStack {
        Text(food.emoji)
            .font(.largeTitle)
            .frame(width: 40, alignment: .leading)

        VStack(alignment: .leading, spacing: 4) {
            Text(food.item)
                .font(.headline)
                .foregroundColor(.primary)

            Text(formatDate(food.expires))
                .font(.caption)
                .foregroundColor(.secondary)
        }

        Spacer()
        Image(systemName: "trash")
            .foregroundColor(.red)
    }
    .padding(20)
    .background(Color.white)
    .overlay(
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
    )
    .cornerRadius(15)
}
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date)
}
#Preview {
    Food_Card()
}
