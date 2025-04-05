	//
//  Splash.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct Splash: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            Dashboard() // Main content after splash
        } else {
            VStack {
                Text("🍔") // Splash emoji or logo
                    .font(.system(size: 100))
                Text("Welcome to FoodieApp")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .onAppear {
                // Wait for 2 seconds before switching view
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    Splash()
}
