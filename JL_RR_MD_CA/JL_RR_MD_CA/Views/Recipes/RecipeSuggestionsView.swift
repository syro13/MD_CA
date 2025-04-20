//
//  RecipeSuggestionsView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 18/04/25.
//

import SwiftUI

struct RecipeSuggestionsView: View {
    var selectedIngredients: [String]
    @State private var recipes: [Recipe] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading recipes...")
                    .padding(.top, 100)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if recipes.isEmpty {
                Text("No recipes found. Try selecting different ingredients.")
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            VStack {
                                AsyncImage(url: URL(string: recipe.image)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else if phase.error != nil {
                                        Color.red
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(10)

                                Text(recipe.title)
                                    .foregroundColor(.black)
                                    .font(.caption)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 5)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 1)
                            .padding(5)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Suggestions")
        .onAppear(perform: loadRecipes)
    }

    private func loadRecipes() {
        isLoading = true
        errorMessage = nil

        RecipeAPI.shared.fetchRecipes(for: selectedIngredients) { result in
            isLoading = false
            recipes = result
            if result.isEmpty {
                errorMessage = "No matching recipes found for selected ingredients."
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeSuggestionsView(selectedIngredients: ["chocolate", "butter", "eggs"])
    }
}



