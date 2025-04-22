//
//  SelectableFoodCard.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 21/04/25.
//

import SwiftUI

struct SelectableFoodCard: View {
    let food: Food
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        HStack {
            Text(food.emoji)
                .font(.largeTitle)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(food.item.capitalized)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(formatDate(food.expires))
                    .font(.subheadline)
                    .foregroundColor(isExpiringSoon(food.expires) ? .red : .green)
                    .bold()
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .yellow : .gray)
                .font(.title2)
        }
        .padding(20)
        .background(Color(.darkGray))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(15)
        .onTapGesture {
            onTap()
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    func isExpiringSoon(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiry = calendar.startOfDay(for: date)
        if let daysLeft = calendar.dateComponents([.day], from: today, to: expiry).day {
            return daysLeft <= 3 && daysLeft >= 0
        }
        return false
    }
}


#Preview {
    SelectableFoodCard(
        food: Food(item: "Chocolate", emoji: "🍫", expires: Date()),
        isSelected: true,
        onTap: {}
    )
    .padding()
    .background(Color.black)  
}
