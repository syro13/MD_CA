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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.yellow)
                    .frame(height: 150)
                    .ignoresSafeArea(edges: .top)

                HStack{
                    Button {
                        dismiss()
                    } label: {
                        HStack (spacing: 0) {
                            Image(systemName: "chevron.left")
                            Text("BACK")
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                    }

                    Spacer()

                    Text("Instructions")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                    Spacer()
                }
                .padding(30)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(recipe.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.yellow)
                        .cornerRadius(20)
                        .padding(.horizontal)

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
                    .cornerRadius(20)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients:")
                            .font(.headline)
                            .foregroundColor(.white)

                        ForEach(recipe.usedIngredients + recipe.missedIngredients) { ing in
                            Text("• \(ing.original)")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)

                    if !instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recipe:")
                                .font(.headline)
                                .foregroundColor(.white)

                            ForEach(instructions.indices, id: \.self) { i in
                                Text(instructions[i])
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            .offset(y: -50)
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255))
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
