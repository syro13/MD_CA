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

    // Fetch recipe summary
    func fetchSummary(for recipeID: Int, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/summary?apiKey=\(apiKey)") else {
            completion("No summary available.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion("Error fetching summary.")
                return
            }

            do {
                let result = try JSONDecoder().decode([String: String].self, from: data)
                let summaryHTML = result["summary"] ?? "No summary found."
                let strippedSummary = summaryHTML.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                DispatchQueue.main.async {
                    completion(strippedSummary)
                }
            } catch {
                print("Error decoding summary: \(error)")
                completion("No summary found.")
            }
        }.resume()
    }

    // Fetch analyzed instructions
    func fetchInstructions(for recipeID: Int, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/analyzedInstructions?apiKey=\(apiKey)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let instructionsData = try JSONDecoder().decode([Instruction].self, from: data)
                let steps = instructionsData.first?.steps.map { $0.step } ?? []
                DispatchQueue.main.async {
                    completion(steps)
                }
            } catch {
                print("Error decoding instructions: \(error)")
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

