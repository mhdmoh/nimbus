//
//  NimbusEndpoints.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

struct NimbusEndpoints: APIEndpointProtocol {
    typealias Endpoint = Endpoints
    
    
    enum Endpoints: String {
        case current = "/weather"
    }
    
    func currentWeather(queries: WeatherQueries) -> APIRequest<EmptyBody, WeatherQueries, EmptyHeaders, CurrentWeather> {
        return .init(path: Endpoint.current.rawValue,queries: queries)
    }
}