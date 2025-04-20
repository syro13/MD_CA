//
//  RoundedCorners.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 17/04/25.
//

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = 40.0
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview{
    RoundedCorners()
}
