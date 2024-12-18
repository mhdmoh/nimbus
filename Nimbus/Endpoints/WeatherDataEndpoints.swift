//
//  NimbusEndpoints.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

struct WeatherDataEndpoints: APIEndpointProtocol {
    typealias Endpoint = Endpoints
    
    
    enum Endpoints: String {
        case current = "/data/2.5/weather"
        case forecast = "/data/2.5/forecast"
    }
    
    func currentWeather(queries: WeatherQueries) -> APIRequest<EmptyBody, WeatherQueries, EmptyHeaders, CurrentWeather> {
        return .init(path: Endpoint.current.rawValue,queries: queries)
    }
    
    func weatherForecast(queries: WeatherQueries) -> APIRequest<EmptyBody, WeatherQueries, EmptyHeaders, Forecast> {
        return .init(path: Endpoint.forecast.rawValue,queries: queries)
    }
}
