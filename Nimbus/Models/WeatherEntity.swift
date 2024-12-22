//
//  WeatherEntity.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 22/12/2024.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class WeatherEntity {
    @Attribute(.unique)
    var locationName: String
    
    var latitude: Double
    var longitude: Double
    
    var weatherDescription: String?
    var lastKnownWeather: Double?
    
    var icon: String?
    
    func latlng() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(
        locationName: String,
        latitude: Double,
        longitude: Double,
        weatherDescription: String? = nil,
        lastKnownWeather: Double? = nil,
        icon: String? = nil
    ) {
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.weatherDescription = weatherDescription
        self.lastKnownWeather = lastKnownWeather
        self.icon = icon
    }
    
    convenience init (weather: CurrentWeather) {
        self.init(
            locationName: weather.locationName,
            latitude: weather.coord.lat,
            longitude: weather.coord.lon,
            weatherDescription: weather.weather.first?.description,
            lastKnownWeather: weather.main.temp,
            icon: weather.weather.first?.icon
        )
    }
}
