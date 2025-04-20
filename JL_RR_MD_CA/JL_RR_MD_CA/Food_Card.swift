import SwiftUI



struct Food_Card: View {
    @Binding var foods: [Food]
    
    var body: some View {
        VStack {
            ForEach(foods) { food in
                foodRow(for: food)
            }
        }
    }

    @ViewBuilder
    func foodRow(for food: Food) -> some View {
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
                    .font(.caption)
                    .foregroundColor(.white)
                
                if isExpiringSoon(food.expires) {
                    Text("Expires Soon")
                        .font(.caption2)
                        .foregroundColor(.red)
                        .bold()
                }
            }

            Spacer()

            Button(action: {
                if let index = foods.firstIndex(of: food) {
                    foods.remove(at: index)
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(20)
        .background(Color(.darkGray))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(15)
        .background(Color(red: 40/255, green: 39/255, blue: 39/255)
            .ignoresSafeArea())
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
    Food_Card(foods: .constant([
        Food(item: "Apples", emoji: "🍎", expires: Date()),
        Food(item: "Cheese", emoji: "🧀", expires: Date().addingTimeInterval(884000))
    ]))
}
