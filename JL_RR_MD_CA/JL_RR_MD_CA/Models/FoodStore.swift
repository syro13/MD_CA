import SwiftUI

class FoodStore: ObservableObject {
    @Published var foods: [Food] {
        didSet {
            saveFoods()
        }
    }

    private let saveKey = "SavedFoods"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Food].self, from: data) {
            self.foods = decoded
        } else {
            self.foods = []
        }
    }

    func add(_ food: Food) {
        foods.append(food)
    }

    func delete(at offsets: IndexSet) {
        foods.remove(atOffsets: offsets)
    }

    private func saveFoods() {
        if let encoded = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
