//
//  NimbusDS.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol NimbusDSProtocol {
    func currentWeather(queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel>
}

struct NimbusDS: NimbusDSProtocol {
    private let client: APIClient
    private let endpoint: NimbusEndpoints
    
    init(client: APIClient, endpoint: NimbusEndpoints) {
        self.client = client
        self.endpoint = endpoint
    }
    
    func currentWeather(queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel> {
        return await client.request(using: endpoint.currentWeather(queries: queries))
    }
}
