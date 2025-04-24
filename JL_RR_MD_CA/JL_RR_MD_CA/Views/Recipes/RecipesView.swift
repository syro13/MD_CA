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
    @Binding var foods: [Food]
    @State private var selectedIngredients: Set<String> = []
    @State private var path = NavigationPath()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack(path: $path) {
            VStack{
            
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

                        Text("Recipes")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                        
                        Spacer()
                        Spacer()
                    }
                    .padding(30)
                }
                    
                HStack {
                    Spacer()
                    Text("Select your ingredients to view recipes:")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding()
                    Spacer()
                }
                .background(Color.yellow)
                .cornerRadius(20)
                .offset(y: -30)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(foods, id: \.self) { food in
                            SelectableFoodCard(
                                food: food,
                                isSelected: selectedIngredients.contains(food.item)
                            ) {
                                if selectedIngredients.contains(food.item) {
                                    selectedIngredients.remove(food.item)
                                } else {
                                    selectedIngredients.insert(food.item)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

           
                Button(action: {
                    path.append(RecipeNavRoute.suggestions(Array(selectedIngredients)))
                }) {
                    Text("GET  RECIPES")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .font(.headline)
                        .cornerRadius(30)
                        .padding(.horizontal)
                        .padding(.top)
                }
            }
            .background(Color(red: 40/255, green: 39/255, blue: 39/255))
            .navigationDestination(for: RecipeNavRoute.self) { route in
                switch route {
                case .suggestions(let selectedIngredients):
                    RecipeSuggestionsView(selectedIngredients: selectedIngredients)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}


#Preview {
    RecipesView(foods: .constant([
        Food(item: "Chocolate", emoji: "🍫", expires: Date().addingTimeInterval(86400 * 2)),
        Food(item: "Butter", emoji: "🧈", expires: Date().addingTimeInterval(86400 * 5)),
        Food(item: "Eggs", emoji: "🥚", expires: Date().addingTimeInterval(-86400 * 3))
    ]))
}
