//
//  MapView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 19/12/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var position: CLLocationCoordinate2D?
    
    var popWithResult: (CLLocationCoordinate2D) -> Void
    
    var body: some View {
        NavigationStack{
            ZStack{
                Map()
                
                Image(systemName: "mappin")
                    .renderingMode(.template)
                    .resizable()
                    .frame(
                        width: 20,
                        height: 48
                    )
                    .foregroundStyle(.foreground)
                    .offset(y: -23)
                
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(
                        width: 20,
                        height: 48
                    )
            }
            .navigationTitle("Choose A Location")
            .toolbarBackgroundVisibility(.visible, for: .bottomBar)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Choose Location") {
                    if let pos = position {
                        popWithResult(pos)
                    }
                }
                .disabled(position == nil)
            }
        }
        .onMapCameraChange { context in
            position = context.region.center
        }
    }
}

#Preview {
    MapView() { loc in
        
    }
}
