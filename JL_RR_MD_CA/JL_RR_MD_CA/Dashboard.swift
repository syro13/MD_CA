//
//  Dashboard.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 04/04/25.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        VStack{
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 30))
                    Text("Find your food")
                    Spacer()
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 30))
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(15)
            }
            .padding()
            Food_Card()
                .padding(.horizontal)
            Spacer()
            HStack{
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "shippingbox")
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                Spacer()
                Image(systemName: "receipt")
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 30))
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    Dashboard()
}
