//
//  FoodRowView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 23/04/25.
//


import SwiftUI

struct FoodRowView: View {
    var food: Food
    @Binding var foods: [Food]
    
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .trailing) {
            // Background (red with trash icon)
            Rectangle()
                .fill(Color.red)
                .cornerRadius(15)
                .frame(height: 80)
                .overlay(
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.trailing, 20),
                    alignment: .trailing
                )

            // Foreground card
            HStack {
                Text(food.emoji)
                    .font(.largeTitle)
                    .frame(width: 40, alignment: .leading)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text(food.item)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(formatDate(food.expires))
                        .font(.subheadline)
                        .foregroundColor(isExpiringSoon(food.expires) ? .red : .green)
                        .bold()
                }

                Spacer()
            }
            .padding(20)
            .background(Color(.darkGray))
            .cornerRadius(15)
            .offset(x: dragOffset)
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onChanged { value in
                        if abs(value.translation.width) > abs(value.translation.height),
                           value.translation.width < 0 {
                            dragOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -100 {
                            withAnimation {
                                if let index = foods.firstIndex(of: food) {
                                    foods.remove(at: index)
                                }
                            }
                        } else {
                            withAnimation {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .animation(.easeInOut, value: dragOffset)
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
