//
//  Food_Card.swift
//  JL_RR_MD_CA
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct Food_Card: View {
    var body: some View {
        var foods: [Food] = testData
        List(foods){food in
            HStack {
                Text(food.emoji)
                    .font(.largeTitle)
                Spacer()
                Text(food.item)
                    .foregroundColor(.white)
                
            }
            .frame(width: 300, height: 10)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
        }
    }
}

#Preview {
    Food_Card()
}
