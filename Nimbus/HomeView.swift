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
    @StateObject var forecastViewModel: WeatherForecastViewModel
    
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
        
        _forecastViewModel = StateObject(
            wrappedValue: WeatherForecastViewModel(
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
            .padding(.horizontal)
            
            VGap(space: 32)
            
            ForecastTypeSelector(){ type in
                forecastViewModel.selectedForecastType = type
            }
            .padding(.horizontal)
            
            VGap()
            
            GeometryReader{ reader in
                ScrollView(.horizontal){
                    Group{
                        if let forecast = forecastViewModel.forecast {
                            HStack(spacing: 0) {
                                ForEach(forecast, id: \.dt) {item in
                                    ForecastItemView(item: item)
                                        .frame(
                                            width: (reader.size.width / 4) - 6
                                        )
                                }
                            }
                        } else {
                            HStack(spacing: 0) {
                                ForecastItemView(item: ForecastItem.example)
                                    .frame(
                                        width: (reader.size.width / 4)
                                    )
                            }
                            .redacted(reason: .placeholder)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .scrollIndicators(.hidden)
            }
            
            Spacer()
            
        }
        .onAppear{
            locationManager.requestAuthorization()
        }
        .onReceive(locationManager.$location) { location in
            if location != nil {
                Task{
                    await viewModel.fetchCurrentWeather(location: location!)
                    await forecastViewModel.forecast(location: location!)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
