//
//  CurrentWeather.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    static let example = CurrentWeather(
        coord: Coord(lon: 19.0402, lat: 47.4979),
        weather: [
            Weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04d")
        ],
        base: "stations",
        main: Main(
            temp: 5.04,
            feelsLike: 5.04,
            tempMin: 4.76,
            tempMax: 6.7,
            pressure: 1026,
            humidity: 88,
            seaLevel: 1026,
            grndLevel: 1004
        ),
        visibility: 10000,
        wind: Wind(speed: 0.45, deg: 248, gust: 1.79),
        clouds: Clouds(all: 100),
        dt: 1734511843,
        sys: Sys(
            type: 2,
            id: 2009313,
            country: "HU",
            sunrise: 1734503236,
            sunset: 1734533636
        ),
        timezone: 3600,
        id: 3054643,
        name: "Budapest",
        cod: 200
    )
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure, humidity
        case seaLevel
        case grndLevel
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

