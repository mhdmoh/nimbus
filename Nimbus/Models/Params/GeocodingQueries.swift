//
//  GeocodingQueries.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import Foundation


struct GeocodingQueries: Encodable, APIQueriesProtocol {
    let latitude: Double
    let longitude: Double
    
    func getQueries() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "limit", value: "1")
        ]
    }
}
