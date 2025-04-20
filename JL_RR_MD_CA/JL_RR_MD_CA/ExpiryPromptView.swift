//
//  ExpiryPromptView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 20/04/25.
//


import SwiftUI

struct ExpiryPromptView: View {
    let product: Product
    @Binding var expiryDate: Date
    let onAdd: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Add Expiry Date")) {
                    Text("\(product.emoji) \(product.name)")
                        .font(.headline)

                    DatePicker("Use by", selection: $expiryDate, displayedComponents: .date)
                }

                Button("Add to My Foods") {
                    onAdd()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .foregroundColor(.black)

                Button("Cancel", role: .cancel) {
                    onCancel()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Confirm Item")
        }
    }
}
struct ExpiryPromptSheet: Identifiable {
    let id = UUID()
    let product: Product
}

#Preview {
    ExpiryPromptView(
        product: Product(name: "Milk", emoji: "🥛"),
        expiryDate: .constant(Date().addingTimeInterval(3 * 86400)),
        onAdd: {
            print("Added!")
        },
        onCancel: {
            print("Cancelled!")
        }
    )
}

