//
//  ContentView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI
import Swinject
import GRDBQuery

struct HomeView: View {
    @EnvironmentStateObject var viewModel: CurrentWeatherViewModel
    @EnvironmentStateObject var locationManager : LocationManagerViewModel
    @EnvironmentStateObject var forecastViewModel: WeatherForecastViewModel
    
    @State var shouldAddNewLocation = false
    
    init() {
        _viewModel = EnvironmentStateObject { env in return CurrentWeatherViewModel(service: env.nimbusService) }
        _forecastViewModel = EnvironmentStateObject { env in return WeatherForecastViewModel(service: env.nimbusService) }
        _locationManager = EnvironmentStateObject { env in return LocationManagerViewModel(service: env.nimbusService) }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                ToolBarView(locationName: locationManager.locationName ?? "Some Location Name"){
                    shouldAddNewLocation = true
                }
                .if(locationManager.locationName == nil){ view in
                    view.redacted(reason: .placeholder)
                }
                .padding()
                
                CurrentWeatherView(weather: viewModel.currentWeather ?? CurrentWeather.example)
                    .if(viewModel.currentWeather == nil) {view in
                        view
                            .redacted(reason: .placeholder)
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
                    NLogger().log("(\(loc.latitude),\(loc.longitude))")
                }
            }
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
        .environment(\.container, Container.setupMockDependencies())
}
