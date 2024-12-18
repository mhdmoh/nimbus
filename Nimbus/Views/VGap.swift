//
//  VGapView.swift
//  NativeBubblz
//
//  Created by Mohamad Mohamad on 15/11/2024.
//

import SwiftUI

struct VGap: View {
    let space: CGFloat
    
    init(space: CGFloat = 16) {
        self.space = space
    }
    
    var body: some View {
        Spacer()
            .frame(height: space)
    }
}

#Preview {
    VGap()
}
