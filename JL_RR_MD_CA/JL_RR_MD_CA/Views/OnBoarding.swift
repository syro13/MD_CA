//
//  OnBoarding.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 15/04/25.
//

import SwiftUI



struct OnboardingScreen: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}

enum OnboardingDestination: Hashable {
    case loginview
}

struct OnBoarding: View {
    @State private var currentIndex = 0
    @Binding var path: NavigationPath
    @AppStorage("seenOnboarding") var seenOnboarding = false

    let screens: [OnboardingScreen] = [
        OnboardingScreen(imageName: "bread", title: "Welcome to Crumbs", subtitle: "Because every bite matters.\nLet’s fight food waste together!"),
        OnboardingScreen(imageName: "scan", title: "Scan & Save", subtitle: "Scan products and track expiry.\nAvoid unnecessary waste."),
        OnboardingScreen(imageName: "recipe", title: "Smart Recipes", subtitle: "Get recipe suggestions\nwith leftovers you already have."),
        OnboardingScreen(imageName: "donate", title: "Share or Donate", subtitle: "Donate food to local banks,\ncharities, or churches.")
    ]

    var body: some View {
            ZStack {
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(screens.enumerated()), id: \.offset) { index, screen in
                            OnboardingSlide(screen: screen)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: UIScreen.main.bounds.height * 0.85)

                    HStack(spacing: 8) {
                        ForEach(screens.indices, id: \.self) { i in
                            Circle()
                                .fill(i == currentIndex ? Color.yellow : Color.gray.opacity(0.5))
                                .frame(width: 10, height: 10)
                        }
                    }

                    HStack {
                        if currentIndex > 0 {
                            Button("BACK") {
                                withAnimation {
                                    currentIndex -= 1
                                }
                            }
                            .foregroundColor(.yellow)
                        } else {
                            Spacer()
                        }

                        Spacer()

                        Button("NEXT") {
                            withAnimation {
                                if currentIndex < screens.count - 1 {
                                    currentIndex += 1
                                } else {
                                    path.append(OnboardingDestination.loginview)
                                    seenOnboarding = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.yellow)
                        .cornerRadius(30)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 50)
            .background(Color(red: 40/255, green: 39/255, blue: 39/255)
                .ignoresSafeArea())
            .navigationDestination(for: OnboardingDestination.self) { destination in
                switch destination {
                case .loginview:
                    LoginView(path: $path)
                        .navigationBarHidden(true)
                }
            }
        }
}


struct OnboardingSlide: View {
    let screen: OnboardingScreen

    var body: some View {
        VStack{
            Image(screen.imageName)
                .resizable()
                .aspectRatio(440/519, contentMode: .fill)
                .clipped()
                .ignoresSafeArea(.all)
                
            VStack{
                Text(screen.title)
                    .font(.title)
                    .foregroundColor(.yellow)

                Text(screen.subtitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .background(Color(red: 40/255, green: 39/255, blue: 39/255))
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255))
    }
}





#Preview {
    OnBoarding(path: .constant(NavigationPath()))
}
