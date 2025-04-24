import SwiftUI

struct Food_Card: View {
    @Binding var foods: [Food]

    var body: some View {
        if foods.isEmpty {
            Image("no_food")
                .resizable()
                .scaledToFit()
                .padding()
        } else {
            LazyVStack(spacing: 12) {
                ForEach(foods) { food in
                    FoodRowView(food: food, foods: $foods)
                }
            }
            .padding(.top)
        }
    }
}


#Preview {
    Food_Card(foods: .constant([
        Food(item: "Apples", emoji: "🍎", expires: Date()),
        Food(item: "Cheese", emoji: "🧀", expires: Date().addingTimeInterval(884000))
    ]))
}
