//
//  Dashboard.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 04/04/25.
//

import SwiftUI

struct Dashboard: View {
    @State private var showAddFoodSheet = false
    @State private var showScanner = false
    @State private var showRecipes = false
    @State private var expiryPromptSheet: ExpiryPromptSheet? = nil
    @State private var expiryDate = Date()
    @StateObject private var foodStore = FoodStore()

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    Text("Find your food")
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .onTapGesture {
                            showScanner = true
                        }
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(15)
            }
            .padding()

            Food_Card(foods: $foodStore.foods)
                .padding(.horizontal)

            Spacer()

            HStack {
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "shippingbox")
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .onTapGesture {
                        showAddFoodSheet = true
                    }
                Spacer()
                Image(systemName: "receipt")
                    .font(.system(size: 30))
                    .onTapGesture {
                        showRecipes = true
                    }
                Spacer()
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 30))
            }
            .padding(.horizontal)
            .foregroundColor(.yellow)
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255)
            .ignoresSafeArea())
        .sheet(isPresented: $showAddFoodSheet) {
            AddFoodView(foods: $foodStore.foods)
        }
        .sheet(isPresented: $showScanner) {
            ScannerView { scannedCode in
                print("Scanned barcode: \(scannedCode)")
                let productList = ProductLookup.loadProducts()
                if let matchedProduct = productList[scannedCode] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        expiryPromptSheet = ExpiryPromptSheet(product: matchedProduct)
                    }
                }
                else {
                    print("No match for barcode: \(scannedCode)")
                }
                showScanner = false
            }
        }
        .sheet(item: $expiryPromptSheet) { sheet in
            ExpiryPromptView(
                product: sheet.product,
                expiryDate: $expiryDate,
                onAdd: {
                    let newFood = Food(item: sheet.product.name, emoji: sheet.product.emoji, expires: expiryDate)

                    if !foodStore.foods.contains(where: { $0.item == newFood.item }) {
                        foodStore.foods.append(newFood)
                    }

                    expiryPromptSheet = nil
                    expiryDate = Date()
                },
                onCancel: {
                    expiryPromptSheet = nil
                }
            )
        }
        .fullScreenCover(isPresented: $showRecipes) {
            RecipesView(foods: $foodStore.foods)
        }
    }
}

struct AddFoodView: View {
    @Binding var foods: [Food]
    @Environment(\.dismiss) var dismiss

    @State private var item = ""
    @State private var emoji = ""
    @State private var expiryDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item", text: $item)
                TextField("Emoji", text: $emoji)
                DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)

                Button("Add") {
                    let newFood = Food(item: item, emoji: emoji, expires: expiryDate)
                    foods.append(newFood)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .foregroundColor(.black)
            }
            .navigationTitle("Add New Food")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Dashboard()
}
