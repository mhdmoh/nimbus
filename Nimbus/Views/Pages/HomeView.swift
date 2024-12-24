//
//  ContentView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI
import Swinject
import GRDBQuery
import CoreLocation

struct HomeView: View {
    @EnvironmentStateObject private var viewModel: CurrentWeatherViewModel
    @EnvironmentStateObject private var locationManager : LocationManagerViewModel
    @EnvironmentStateObject private var forecastViewModel: WeatherForecastViewModel
    
    @State private var shouldAddNewLocation = false
    
    init() {
        _viewModel = EnvironmentStateObject { env in return CurrentWeatherViewModel(service: env.nimbusService) }
        _forecastViewModel = EnvironmentStateObject { env in return WeatherForecastViewModel(service: env.nimbusService) }
        _locationManager = EnvironmentStateObject { env in return LocationManagerViewModel(service: env.nimbusService) }
    }
    
    private func handleLocationEvents(_ event: ToolBarViewEvent) {
        switch event {
        case .addNewLocation:
            shouldAddNewLocation = true
        case .selectNewLocation(let loc):
            locationManager.location = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        }
    }
    
    private func fetchWeatherData(from location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        Task{
            await viewModel.fetchCurrentWeather(location: location)
            await forecastViewModel.fetchForecast(location: location)
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                ToolBarView(locationName: locationManager.locationName ?? "Some Location Name", delegate: handleLocationEvents)
                    .redactedIf(locationManager.locationName == nil)
                    .padding()
                
                CurrentWeatherView(weather: viewModel.currentWeather ?? CurrentWeather.example)
                    .redactedIf(viewModel.currentWeather == nil)
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
                                            .frame( width: (reader.size.width / 4) - 6 )
                                    }
                                }
                            } else {
                                HStack(spacing: 0) {
                                    ForecastItemView(item: ForecastItem.example)
                                        .frame( width: (reader.size.width / 4) )
                                }
                                .redacted(reason: .placeholder)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .scrollIndicators(.hidden)
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $shouldAddNewLocation) {
                MapView(){ loc in
                    shouldAddNewLocation = false
                    locationManager.location = loc
                }
            }
            .navigationDestination(isPresented: $locationManager.denied) {
                LocationPermissionView() { event in
                    switch event {
                    case .givePermission:
                        openAppSettings()
                    case .selectOnMap:
                        shouldAddNewLocation = true
                    }
                }
            }
        }
        .onAppear{ locationManager.requestAuthorization() }
        .onReceive(locationManager.$location, perform: fetchWeatherData)
    }
    
    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:]) { value in
                if value {
                    locationManager.requestAuthorization()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.container, Container.setupMockDependencies())
}
