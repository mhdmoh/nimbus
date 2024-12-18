//
//  ContentView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: CurrentWeatherViewModel
    @StateObject var locationManager = LocationManager()
    
    init() {
        _viewModel = StateObject(
            wrappedValue: CurrentWeatherViewModel(
                service: NimbusService(
                    repo: NimbusRepo(
                        remoteDS: NimbusDS(
                            client: APIClient(),
                            endpoint: NimbusEndpoints()
                        )
                    )
                )
            )
        )
    }
    
    var body: some View {
        VStack {
            Group {
                if let currentWeather = viewModel.currentWeather {
                    CurrentWeatherView(weather: currentWeather)
                } else {
                    CurrentWeatherView(weather: CurrentWeather.example)
                        .redacted(reason: .placeholder)
                }
            }
        }
        .padding()
        .onAppear{
            locationManager.requestAuthorization()
        }
        .onReceive(locationManager.$location) { location in
            if location != nil {
                Task{
                    await viewModel.fetchCurrentWeather(location: location!)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
