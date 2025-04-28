	//
//  Splash.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct Splash: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("seenOnboarding") var seenOnboarding = false
    @State private var isActive = false
    @Binding var path: NavigationPath

    var body: some View {
        if isActive {
            if isLoggedIn{
                Dashboard(path: $path)
            } else {
                if seenOnboarding{
                    LoginView(path: $path)
                } else {
                OnBoarding(path: $path)
                }
            }
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
    Splash(path: .constant(NavigationPath()))
}
