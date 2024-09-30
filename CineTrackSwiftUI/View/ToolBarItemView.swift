//
//  ToolBarItemView.swift
//  CineTrackSwiftUI
//
//  Created by John on 27/09/24.
//

import SwiftUI

struct ToolBarItemView: View {
    @Binding var segment: Sections
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Sections.allCases, id: \.self) { buttonTitle in
                let buttonTitle = buttonTitle
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        segment = buttonTitle
                    }
                }) {
                    Text(buttonTitle.description)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule()
                                .fill(segment == buttonTitle ? Color.primary : Color.clear)
                        )
                        .foregroundColor(segment == buttonTitle ? .purple : .primary)
                }
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
    }
}

#Preview {
    ToolBarItemView(segment: .constant(.upcoming))
}
