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
    case dashboard
}

struct OnBoarding: View {
    @State private var currentIndex = 0
    @State private var path = NavigationPath()

    let screens: [OnboardingScreen] = [
        OnboardingScreen(imageName: "bread1", title: "Welcome to Crumbs", subtitle: "Because every bite matters.\nLet’s fight food waste together!"),
        OnboardingScreen(imageName: "bread1", title: "Scan & Save", subtitle: "Scan products and track expiry.\nAvoid unnecessary waste."),
        OnboardingScreen(imageName: "bread1", title: "Smart Recipes", subtitle: "Get recipe suggestions\nwith leftovers you already have."),
        OnboardingScreen(imageName: "bread1", title: "Share or Donate", subtitle: "Donate food to local banks,\ncharities, or churches.")
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(red: 40/255, green: 39/255, blue: 39/255)
                    .ignoresSafeArea()

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
                                    path.append(OnboardingDestination.dashboard)
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
            .navigationDestination(for: OnboardingDestination.self) { destination in
                switch destination {
                case .dashboard:
                    Dashboard()
                }
            }
        }
    }
}


struct OnboardingSlide: View {
    let screen: OnboardingScreen

    var body: some View {
        VStack(spacing: 0) {
            Image(screen.imageName)
                .ignoresSafeArea(.all)

            VStack(spacing: 20) {
                Text(screen.title)
                    .font(.title)
                    .foregroundColor(.yellow)

                Text(screen.subtitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.top, 24)
            .background(Color(red: 40/255, green: 39/255, blue: 39/255))
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255))
    }
}





#Preview {
    OnBoarding()
}
