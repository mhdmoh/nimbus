//
//  ReverseGeocodingResponseElement.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//


// MARK: - ReverseGeocodingResponseElement
struct ReverseGeocodingElement: Codable {
    let name: String
    let localNames: [String: String]
    let lat, lon: Double
    let country: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames
        case lat, lon, country
    }
}

typealias ReverseGeocodingResponse = [ReverseGeocodingElement]
