//
//  HGap.swift
//  NativeBubblz
//
//  Created by Mohamad Mohamad on 23/11/2024.
//

import SwiftUI

struct HGap: View {
    let space: CGFloat
    
    init(space: CGFloat = 16) {
        self.space = space
    }
    
    var body: some View {
        Spacer()
            .frame(width: space)
    }
}

#Preview {
    HGap()
}

