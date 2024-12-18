//
//  ContentView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: CurrentWeatherViewModel
    
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
            Task {
                await viewModel.fetchCurrentWeather()
            }
        }
    }
}

#Preview {
    HomeView()
}
