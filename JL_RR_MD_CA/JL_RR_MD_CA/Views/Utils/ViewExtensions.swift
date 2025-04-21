//
//  ViewExtensions.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 17/04/25.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow { placeholder().foregroundColor(.gray) }
            self
        }
    }
}

