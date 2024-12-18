//
//  NimbusRepo.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol NimbusRepoProtocol {
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel>
    func weatherForecast(_ queries: WeatherQueries) async -> Result<Forecast, APIErrorModel>
}

struct NimbusRepo: NimbusRepoProtocol, BaseRepository {
    private let remoteDS: NimbusDSProtocol
    
    init(remoteDS: NimbusDSProtocol) {
        self.remoteDS = remoteDS
    }
    
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel> {
        return await sendRequest {
            return await remoteDS.currentWeather(queries: queries)
        }
    }
    
    func weatherForecast(_ queries: WeatherQueries) async -> Result<Forecast, APIErrorModel> {
        return await sendRequest {
            return await remoteDS.weatherForecast(queries: queries)
        }
    }
}
