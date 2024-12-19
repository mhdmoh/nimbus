//
//  ToolBarView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import SwiftUI

struct ToolBarView: View {
    let locationName: String
    let addNewLocationDelegate: () -> Void
    
    private let options: [String]
    
    
    init(locationName: String, addNewLocationDelegate: @escaping () -> Void) {
        self.addNewLocationDelegate = addNewLocationDelegate
        self.locationName = locationName
        self.options = ["Choose new location", locationName]
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
               Text("Welcome Back To NIMBUS")
                    .font(.caption)
                    .unredacted()
                
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option){
                            if option == "Choose new location" {
                                addNewLocationDelegate()
                            }
                        }
                    }
                } label: {
                    HStack{
                        Text(locationName)
                            .font(.title3.bold())
                            .foregroundStyle(.foreground)
                        
                        Image(systemName: "chevron.down")
                            .unredacted()
                    }
                        
                }
                .buttonStyle(.plain)

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
    ) {
        
    }
}
