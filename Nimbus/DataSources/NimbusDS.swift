//
//  NimbusDS.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol NimbusDSProtocol {
    func currentWeather(queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel>
    func weatherForecast(queries: WeatherQueries) async -> Result<Forecast, APIErrorModel>
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel>
}

struct NimbusDS: NimbusDSProtocol {
    private let client: APIClientProtocol
    
    private let weatherDataEndpoint: WeatherDataEndpoints
    private let geoDataEndpoint: GeoDataEndpoints
    
    init(client: APIClientProtocol, weatherDataEndpoint: WeatherDataEndpoints, geoDataEndpoint: GeoDataEndpoints) {
        self.client = client
        self.weatherDataEndpoint = weatherDataEndpoint
        self.geoDataEndpoint = geoDataEndpoint
    }
    
    func currentWeather(queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel> {
        return await client.request(using: weatherDataEndpoint.currentWeather(queries: queries))
    }
    
    func weatherForecast(queries: WeatherQueries) async -> Result<Forecast, APIErrorModel> {
        return await client.request(using: weatherDataEndpoint.weatherForecast(queries: queries))
    }
    
    func reverseGeocoding(queries: GeocodingQueries) async -> Result<ReverseGeocodingElement, APIErrorModel> {
        return await client.request(using: geoDataEndpoint.reverseGeocoding(queries: queries)).map { $0.first! }
    }
}
