import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Splash(path: $path)
                .navigationBarHidden(true)
                .navigationDestination(for: AuthNavigation.self) { route in
                    switch route {
                    case .dashboard:
                        Dashboard(path: $path)
                            .navigationBarHidden(true)
                    }
                }
                .navigationDestination(for: OnboardingDestination.self) { destination in
                    switch destination {
                    case .loginview:
                        LoginView(path: $path)
                            .navigationBarHidden(true)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
