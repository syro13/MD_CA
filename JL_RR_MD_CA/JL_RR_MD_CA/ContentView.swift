//
//  ContentView.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            Splash(path: $path)
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}

