//
//  JL_RR_MD_CAApp.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

@main
struct JL_RR_MD_CAApp: App {
    @StateObject private var foodStore = FoodStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(foodStore)
        }
    }
}
