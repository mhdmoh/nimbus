//
//  NimbusService.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol NimbusServiceProtocol {
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel>
    func weatherForecast(_ queries: WeatherQueries) async -> Result<Forecast, APIErrorModel>
    func updateWeathers() async -> Result<Bool, APIErrorModel>
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel>
}

struct NimbusService: NimbusServiceProtocol {
    private let repo: NimbusRepoProtocol
    
    init(repo: NimbusRepoProtocol) {
        self.repo = repo
    }
    
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel> {
        return await repo.currentWeather(queries)
    }
    
    func weatherForecast(_ queries: WeatherQueries) async -> Result<Forecast, APIErrorModel> {
        return await repo.weatherForecast(queries)
    }
    
    func updateWeathers() async -> Result<Bool, APIErrorModel> {
        return await repo.updateWeathers()
    }
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel> {
        return await repo.reverseGeocoding(queries: queries)
    }
}
