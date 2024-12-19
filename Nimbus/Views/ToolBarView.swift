//
//  ToolBarView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import SwiftUI

struct ToolBarView: View {
    let locationName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
               Text("Welcome Back To NIMBUS")
                    .font(.caption)
                    .unredacted()
                
               Text(locationName)
                    .font(.title3.bold())
            }
            
            Spacer()
            
            Image(.menu)
                .renderingMode(.template)
                .foregroundStyle(.foreground)
        }
    }
}

#Preview {
    ToolBarView(
        locationName: "HU, Budapest"
    )
}
