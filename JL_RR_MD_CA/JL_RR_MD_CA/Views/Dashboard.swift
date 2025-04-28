//
//  Dashboard.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 04/04/25.
//

import SwiftUI
import MapKit
import UserNotifications

struct Dashboard: View {
    @Binding var path: NavigationPath
    @State private var showAddFoodSheet = false
    @State private var showScanner = false
    @State private var showRecipes = false
    @State private var expiryPromptSheet: ExpiryPromptSheet? = nil
    @State private var expiryDate = Date()
    @StateObject private var foodStore = FoodStore()
    @State private var showDonation = false
    @StateObject private var locationManager = LocationManager()
    @StateObject private var donationController = DonationController()
    @State private var address: String = "Dublin"
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.yellow)
                    .frame(height: 150)
                    .ignoresSafeArea(edges: .top)

                HStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)

                    Spacer()
                    Spacer()

                    Image(systemName: "bell.badge")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .onTapGesture {
                            requestNotificationPermission()
                            scheduleTestNotification()
                        }
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .onTapGesture {
                            showScanner = true
                        }
                }
                .padding(30)
            }

            ScrollView {
                VStack(spacing: 16) {
                    Food_Card(foods: $foodStore.foods)
                }
                .padding(.trailing, 40)
                .padding(.bottom, 20)
                .padding(10)
            }

            HStack {
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "shippingbox")
                    .font(.system(size: 30))
                    .onTapGesture {
                        showDonation = true
                    }
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .onTapGesture {
                        showAddFoodSheet = true
                    }
                Spacer()
                Image(systemName: "receipt")
                    .font(.system(size: 30))
                    .onTapGesture {
                        showRecipes = true
                    }
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 30))
                    .onTapGesture {
                        showLogoutAlert = true
                    }
                    .alert("Log Out", isPresented: $showLogoutAlert) {
                        Button("Log Out", role: .destructive) {
                            isLoggedIn = false
                            KeychainHelper.delete(service: "CrumbsLogin", account: "user")
                                
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                path = NavigationPath()
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .foregroundColor(.yellow)
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255)
            .ignoresSafeArea())
        .sheet(isPresented: $showAddFoodSheet) {
            AddFoodView(foods: $foodStore.foods)
        }
        .fullScreenCover(isPresented: $showScanner) {
            ZStack {
                ScannerView { scannedCode in
                    print("Scanned barcode: \(scannedCode)")
                    let productList = ProductLookup.loadProducts()
                    if let matchedProduct = productList[scannedCode] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            expiryPromptSheet = ExpiryPromptSheet(product: matchedProduct)
                        }
                    } else {
                        print("No match for barcode: \(scannedCode)")
                    }
                    showScanner = false
                }

                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showScanner = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    Spacer()
                }

                VStack(spacing: 20) {
                    Text("Scan a barcode")
                        .font(.headline)
                        .foregroundColor(.white)

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.yellow, lineWidth: 4)
                        .frame(width: 250, height: 150)

                    Spacer()
                }
                .padding(.top, 100)
            }
            .background(Color(red: 40/255, green: 39/255, blue: 39/255).ignoresSafeArea())
        }
        .sheet(item: $expiryPromptSheet) { sheet in
            ExpiryPromptView(
                product: sheet.product,
                expiryDate: $expiryDate,
                onAdd: {
                    let newFood = Food(item: sheet.product.name, emoji: sheet.product.emoji, expires: expiryDate)

                    if !foodStore.foods.contains(where: { $0.item == newFood.item }) {
                        foodStore.foods.append(newFood)
                        scheduleExpiryNotification(for: newFood)
                    }

                    expiryPromptSheet = nil
                    expiryDate = Date()
                },
                onCancel: {
                    expiryPromptSheet = nil
                }
            )
        }
        .fullScreenCover(isPresented: $showRecipes) {
            RecipesView(foods: $foodStore.foods)
        }
        .fullScreenCover(isPresented: $showDonation) {
            DonationView(
                locationManager: locationManager,
                donationController: donationController,
                address: $address,
                region: $region
            )
        }
    }
}

struct AddFoodView: View {
    @Binding var foods: [Food]
    @Environment(\.dismiss) var dismiss

    @State private var item = ""
    @State private var emoji = ""
    @State private var expiryDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item", text: $item)
                TextField("Emoji", text: $emoji)
                DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)

                Button("Add") {
                    let newFood = Food(item: item, emoji: emoji, expires: expiryDate)
                    foods.append(newFood)
                    if foods.count == 1 {
                        requestNotificationPermission()
                    }
                    scheduleExpiryNotification(for: newFood)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .foregroundColor(.black)
            }
            .navigationTitle("Add New Food")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
        }
    }
}
func scheduleExpiryNotification(for food: Food) {
    let content = UNMutableNotificationContent()
    content.title = "⏰ Food Expiry Reminder"
    content.body = "\(food.item) is expiring soon. Use it before it goes to waste!"
    content.sound = UNNotificationSound.default

    let calendar = Calendar.current
    if let notificationDate = calendar.date(byAdding: .day, value: -1, to: food.expires) {
        let components = calendar.dateComponents([.year, .month, .day], from: notificationDate)
        var triggerDate = DateComponents()
        triggerDate.year = components.year
        triggerDate.month = components.month
        triggerDate.day = components.day
        triggerDate.hour = 10

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "\(food.id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}

func scheduleTestNotification() {
    let content = UNMutableNotificationContent()
    content.title = "🧪 Test Notification"
    content.body = "This is a test notification!"
    content.sound = UNNotificationSound.default

    // Trigger in 10 seconds
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

    let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("❌ Error scheduling test notification: \(error)")
        } else {
            print("✅ Test notification scheduled")
        }
    }
}


#Preview {
    NavigationStack {
        Dashboard(path: .constant(NavigationPath()))
    }
}
