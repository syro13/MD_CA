//
//  DonationView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 22/04/25.
//

import SwiftUI
import MapKit

struct DonationView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var donationController: DonationController
    @Binding var address: String
    @Binding var region: MKCoordinateRegion
    @State private var selectedCompletion: MKLocalSearchCompletion?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.yellow)
                    .frame(height: 150)
                    .ignoresSafeArea(edges: .top)

                HStack{
                    Button {
                        dismiss()
                    } label: {
                        HStack (spacing: 0) {
                            Image(systemName: "chevron.left")
                            Text("BACK")
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                    }

                    Spacer()


                    Text("Donation")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    
                    Spacer()
                    Spacer()
                }
                .padding(30)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Enter your address")
                    .foregroundColor(.white)
                    .font(.title3)
                
                TextField("e.g. 123 Main St, City, Country", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom,5)
                
                Button("Find Nearby Centers") {
                    isLoading = true
                    errorMessage = nil
                    donationController.fetchNearbyCenters(for: address) { result in
                        isLoading = false
                        switch result {
                        case .success(let regionUpdate):
                            region = regionUpdate
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(15)
            }
            .padding()
            .offset(y: -50)

            // Map
            Map(coordinateRegion: $region, annotationItems: donationController.donationCenters) { center in
                MapMarker(coordinate: center.coordinate, tint: .yellow)
            }
            .frame(height: 200)
            .cornerRadius(20)
            .padding(.horizontal)
            .offset(y: -55)

            // Loading Indicator or Error Message
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            // Cards
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(donationController.donationCenters) { center in
                        DonationCenterCard(center: center)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color(red: 40/255, green: 39/255, blue: 39/255))
    }
}

struct DonationView_PreviewWrapper: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var controller = DonationController()
    @State private var address: String = "San Francisco"
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        DonationView(
            locationManager: locationManager,
            donationController: controller,
            address: $address,
            region: $region
        )
        .onAppear {
            controller.donationCenters = [
                DonationCenter(
                    name: "Food Bank SF",
                    address: "123 Main St, San Francisco",
                    coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                ),
                DonationCenter(
                    name: "Local Shelter",
                    address: "456 Elm St, San Francisco",
                    coordinate: CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4294)
                )
            ]
        }
    }
}

#Preview {
    NavigationStack {
        DonationView_PreviewWrapper()
    }
}
