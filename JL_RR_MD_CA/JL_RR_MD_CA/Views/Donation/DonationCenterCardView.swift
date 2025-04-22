//
//  DonationCenterCardView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 22/04/25.
//

import SwiftUI
import MapKit

struct DonationCenterCard: View {
    let center: DonationCenter

    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(center.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(center.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button {
                    openInMaps(center: center)
                } label: {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Get Directions")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.darkGray))
            .cornerRadius(15)
    }

    private func openInMaps(center: DonationCenter) {
        let placemark = MKPlacemark(coordinate: center.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = center.name
        mapItem.openInMaps()
    }
}

#Preview {
    DonationCenterCard(center: DonationCenter(
        name: "Test Food Bank",
        address: "789 Oak St, San Francisco",
        coordinate: CLLocationCoordinate2D(latitude: 37.77, longitude: -122.42)
    ))
    .padding()
    .background(Color.black)
}

