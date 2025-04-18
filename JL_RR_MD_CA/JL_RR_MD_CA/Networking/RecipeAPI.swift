//
//  RecipeAPI.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 18/04/25.
//

import Foundation

class RecipeAPI {
    static let shared = RecipeAPI()
    private let apiKey = "2ca7a925387040fdb9fdfbcfde469ff9"

    // Fetch recipes based on ingredients
    func fetchRecipes(for ingredients: [String], completion: @escaping ([Recipe]) -> Void) {
        let joinedIngredients = ingredients.joined(separator: ",")
        guard let url = URL(string: "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(joinedIngredients)&number=6&apiKey=\(apiKey)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    completion(recipes)
                }
            } catch {
                print("Error decoding recipes: \(error)")
                completion([])
            }
        }.resume()
    }

  
}

// Supporting models for instructions
struct Instruction: Decodable {
    let steps: [Step]
}

struct Step: Decodable {
    let number: Int
    let step: String
}

