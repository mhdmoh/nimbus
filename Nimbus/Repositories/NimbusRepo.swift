//
//  NimbusRepo.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation
import SwiftData

protocol NimbusRepoProtocol {
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel>
    func weatherForecast(_ queries: WeatherQueries) async -> Result<Forecast, APIErrorModel>
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel>
}

struct NimbusRepo: NimbusRepoProtocol, BaseRepository {
    private let remoteDS: NimbusDSProtocol
    private let container: ModelContainer
    
    init(remoteDS: NimbusDSProtocol, container: ModelContainer) {
        self.remoteDS = remoteDS
        self.container = container
    }
    
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel> {
        return await sendRequest {
            return await remoteDS.currentWeather(queries: queries)
        } cacheCall: { curWeather in
            let context = ModelContext(container)
            let entity = WeatherEntity(weather: curWeather)
            context.insert(entity)
            try! context.save()
        }
    }
    
    func weatherForecast(_ queries: WeatherQueries) async -> Result<Forecast, APIErrorModel> {
        return await sendRequest {
            return await remoteDS.weatherForecast(queries: queries)
        }
    }
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel> {
        return await sendRequest {
            return await remoteDS.reverseGeocoding(queries: queries)
        }
    }
}
