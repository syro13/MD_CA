//
//  RecipeSuggestionsView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 18/04/25.
//

import SwiftUI

struct RecipeSuggestionsView: View {
    var selectedIngredients: [String]
    var previewRecipes: [Recipe]? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var recipes: [Recipe] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.yellow)
                    .frame(height: 150)
                    .ignoresSafeArea(edges: .top)

                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "chevron.left")
                            Text("BACK")
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                    }

                    Spacer()

                    Text("Suggestions")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)

                    Spacer()
                    Spacer()
                }
                .padding(30)
            }

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
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)
                                .navigationBarHidden(true)) {
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
                                    .frame(height: 130)
                                    .clipped()
                                    .cornerRadius(10)

                                    Text(recipe.title)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                .background(Color(.darkGray))
                                .cornerRadius(12)
                                .shadow(radius: 1)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .offset(y: -20)
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255))
        .onAppear {
            if let previewRecipes {
                recipes = previewRecipes
            } else {
                loadRecipes()
            }
        }
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


struct RecipeSuggestionsView_PreviewWrapper: View {
    var body: some View {
        RecipeSuggestionsView(
            selectedIngredients: ["chicken", "bread", "cheese"],
            previewRecipes: [
                Recipe(
                    id: 1,
                    title: "Grilled Chicken Sandwich",
                    image: "https://spoonacular.com/recipeImages/716429-312x231.jpg",
                    usedIngredients: [
                        Ingredient(id: 1, name: "chicken", original: "1 grilled chicken breast", image: "")
                    ],
                    missedIngredients: [
                        Ingredient(id: 2, name: "bread", original: "2 slices of bread", image: "")
                    ]
                )
            ]
        )
    }
}

#Preview {
    NavigationStack {
        RecipeSuggestionsView_PreviewWrapper()
    }
}




