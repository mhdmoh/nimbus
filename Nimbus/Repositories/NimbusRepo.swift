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
    func updateWeathers() async -> Result<Bool, APIErrorModel>
    
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
    
    func updateWeathers() async -> Result<Bool, APIErrorModel> {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<WeatherEntity>()
        let queries = (try! context.fetch(fetchDescriptor)).map { WeatherQueries(latitude: $0.latitude, longitude: $0.longitude) }
        
        for query in queries {
            let _ = await currentWeather(query)
        }
        
        return .success(true)
    }
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel> {
        return await sendRequest {
            return await remoteDS.reverseGeocoding(queries: queries)
        }
    }
}
