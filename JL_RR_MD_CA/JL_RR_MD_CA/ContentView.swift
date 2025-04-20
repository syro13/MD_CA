//
//  ContentView.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            LoginView()
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}

