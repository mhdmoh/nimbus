//
//  CurrentWeatherViewModel.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

@MainActor
class CurrentWeatherViewModel: ObservableObject {
    private let service: NimbusService
    
    @Published var currentWeather: CurrentWeather?
    
    init(service: NimbusService) {
        self.service = service
    }
    
    func fetchCurrentWeather() async {
        let result = await service.currentWeather(
            .init(latitude: 47.4979, longitude: 19.0402)
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
