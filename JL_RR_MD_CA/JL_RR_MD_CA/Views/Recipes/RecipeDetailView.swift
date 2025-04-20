//
//  RecipeDetailView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 18/04/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var summary: String = ""
    @State private var instructions: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)

                Text("Ingredients:")
                    .font(.headline)
                    .padding(.horizontal)

                ForEach(recipe.usedIngredients + recipe.missedIngredients) { ing in
                    Text("• \(ing.original)")
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                }

                if !summary.isEmpty {
                    Text("Summary:")
                        .font(.headline)
                        .padding([.top, .horizontal])
                    Text(summary)
                        .padding(.horizontal)
                        .foregroundColor(.primary)
                }

                if !instructions.isEmpty {
                    Text("Instructions:")
                        .font(.headline)
                        .padding([.top, .horizontal])
                    ForEach(instructions.indices, id: \.self) { i in
                        Text("\(i + 1). \(instructions[i])")
                            .padding(.horizontal)
                            .padding(.bottom, 2)
                    }
                }
            }
        }
        .navigationTitle(recipe.title)
        .onAppear(perform: loadDetails)
    }

    private func loadDetails() {
        RecipeAPI.shared.fetchSummary(for: recipe.id) { summaryText in
            summary = summaryText
        }

        RecipeAPI.shared.fetchInstructions(for: recipe.id) { steps in
            instructions = steps
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            id: 12345,
            title: "Chocolate Cake",
            image: "https://img.spoonacular.com/recipes/632660-312x231.jpg",
            usedIngredients: [
                Ingredient(id: 1, name: "chocolate", original: "1 cup chocolate", image: "")
            ],
            missedIngredients: [
                Ingredient(id: 2, name: "flour", original: "2 cups flour", image: "")
            ]
        ))
    }
}
