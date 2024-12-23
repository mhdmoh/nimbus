//
//  MapView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 19/12/2024.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData
import Kingfisher
import GRDBQuery

struct MapView: View {
    @State private var position: CLLocationCoordinate2D?
    @Query() private var locations: [WeatherEntity]
    
    @EnvironmentStateObject var viewModel: MapViewModel
    
    var popWithResult: (CLLocationCoordinate2D) -> Void
    
    init(popWithResult: @escaping (CLLocationCoordinate2D) -> Void) {
        self.popWithResult = popWithResult
        
        _viewModel = EnvironmentStateObject { env in
            return MapViewModel(service: env.nimbusService )
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Map {
                    ForEach(locations) {location in
                        Annotation(coordinate: location.latlng()) {
                            WeatherMapMarkerView(weather: location)
                        } label: {
                            Text(location.locationName)
                        }
                    }
                }
                
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
        .onAppear {
            Task {
                await viewModel.updateWeathers()
            }
        }
    }
}

#Preview {
    MapView() { loc in
        
    }
}
