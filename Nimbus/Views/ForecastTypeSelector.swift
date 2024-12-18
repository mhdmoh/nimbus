//
//  ForcastTypeSelector.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import SwiftUI

struct ForecastTypeSelector: View {
    @State var selected: ForecastTypes = .today
    var onChanged: (ForecastTypes) -> Void
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach(ForecastTypes.allCases, id: \.self) {type in
                VStack{
                    Text(type.rawValue)
                        .fontWeight(selected == type ? .bold : .medium)
                        .foregroundStyle(selected == type ? .primary : .secondary)
                    
                    if selected == type {
                        Circle()
                            .frame(width: 8, height: 8)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        selected = type
                        onChanged(selected)
                    }
                }
            }
            
            Spacer()
        }
        .onAppear{
            onChanged(selected)
        }
    }
}

#Preview {
    ForecastTypeSelector() { type in
        
    }
}
