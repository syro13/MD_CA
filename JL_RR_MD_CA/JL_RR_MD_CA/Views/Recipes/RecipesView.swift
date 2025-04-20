//
//  RecipesView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 18/04/25.
//

import SwiftUI

enum RecipeNavRoute: Hashable {
    case suggestions([String])
}

struct RecipesView: View {
    @State private var ingredients: [String] = ["chocolate", "butter", "eggs"]
    @State private var selectedIngredients: Set<String> = []
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Select your ingredients to view recipes:")
                    .font(.headline)
                    .padding()

                List {
                    ForEach(ingredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient.capitalized)
                            Spacer()
                            Image(systemName: selectedIngredients.contains(ingredient) ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    if selectedIngredients.contains(ingredient) {
                                        selectedIngredients.remove(ingredient)
                                    } else {
                                        selectedIngredients.insert(ingredient)
                                    }
                                }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .frame(height: 200)

                Button(action: {
                    path.append(RecipeNavRoute.suggestions(Array(selectedIngredients)))
                }) {
                    Text("GET RECIPES")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(40)
                        .font(.headline)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Recipes")
            .navigationDestination(for: RecipeNavRoute.self) { route in
                switch route {
                case .suggestions(let selectedIngredients):
                    RecipeSuggestionsView(selectedIngredients: selectedIngredients)
                }
            }
        }
    }
}

#Preview {
    RecipesView()
}
