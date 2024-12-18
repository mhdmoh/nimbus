//
//  CurrentWeatherViewModel.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation
import CoreLocation

@MainActor
class CurrentWeatherViewModel: ObservableObject {
    private let service: NimbusService
    
    @Published var currentWeather: CurrentWeather?
    
    init(service: NimbusService) {
        self.service = service
    }
    
    func fetchCurrentWeather(location: CLLocationCoordinate2D) async {
        let result = await service.currentWeather(
            .init(latitude: location.latitude, longitude: location.longitude)
        )
        switch result {
        case .success(let weather):
            DispatchQueue.main.async {
                self.currentWeather = weather
            }
        case .failure:
            break
        }
    }
}
