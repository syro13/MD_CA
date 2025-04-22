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
        guard let encoded = joinedIngredients.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(encoded)&number=10&ranking=1&ignorePantry=true&apiKey=\(apiKey)") else {
            print("Invalid URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("API error:", error?.localizedDescription ?? "Unknown")
                completion([])
                return
            }

            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    completion(recipes)
                }
            } catch {
                print("Decoding error: \(error)")
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

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Summary API error:", error?.localizedDescription ?? "Unknown")
                completion("Error fetching summary.")
                return
            }

            do {
                let summaryData = try JSONDecoder().decode(RecipeSummary.self, from: data)
                let stripped = summaryData.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                DispatchQueue.main.async {
                    completion(stripped)
                }
            } catch {
                print("Error decoding summary:", error)
                completion("No summary found.")
            }
        }.resume()
    }

    // Fetch recipe instructions
    func fetchInstructions(for recipeID: Int, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/analyzedInstructions?apiKey=\(apiKey)") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Instructions API error:", error?.localizedDescription ?? "Unknown")
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
