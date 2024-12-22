//
//  ToolBarView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import SwiftUI
import SwiftData

enum ToolBarViewEvent {
    case addNewLocation
    case selectNewLocation(WeatherEntity)
}

struct ToolBarView: View {
    let locationName: String
    let delegate: (ToolBarViewEvent) -> Void
    
    @Environment(\.modelContext) var context: ModelContext
    @Query() private var weatherEntities: [WeatherEntity]

    init(locationName: String, delegate: @escaping (ToolBarViewEvent) -> Void) {
        self.delegate = delegate
        self.locationName = locationName
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
               Text("Welcome Back To NIMBUS")
                    .font(.caption)
                    .unredacted()
                
                Menu {
                    Button("Add new location"){
                        delegate(.addNewLocation)
                    }
                    
                    ForEach(weatherEntities, id: \.self) { option in
                        Button(option.locationName){
                            delegate(.selectNewLocation(option))
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
    ) { event in
        
    }
}
