//
//  Forecast.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastItem]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}


// MARK: - List
struct ForecastItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int?
    let pop: Double?
    let sys: Sys
    let dtTxt: String
    
    static let example = ForecastItem(
        dt: 1734544800,
        main: Main(
            temp: 6.05,
            feelsLike: 5.07,
            tempMin: 6.05,
            tempMax: 6.21,
            pressure: 1023,
            humidity: 86,
            seaLevel: 1023,
            grndLevel: 1001
        ),
        weather: [
            Weather(
                id: 800,
                main: "Clear",
                description: "clear sky",
                icon: "01n"
            )
        ],
        clouds: Clouds(
            all: 0
        ),
        wind: Wind(
            speed: 1.56,
            deg: 213,
            gust: 1.7
        ),
        visibility: 10000,
        pop: 0,
        sys: Sys(
            pod: .n,
            type: nil,
            id: nil,
            country: nil,
            sunrise: nil,
            sunset: nil
        ),
        dtTxt: "2024-12-18 18:00:00"
    )
}
