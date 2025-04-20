
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
        OnBoarding()
    } else {
            Image("splash_image")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 40/255, green: 39/255, blue: 39/255))
                .onAppear {
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
