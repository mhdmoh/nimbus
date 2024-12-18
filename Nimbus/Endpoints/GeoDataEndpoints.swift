//
//  GeoDataEndpoints.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import Foundation

struct GeoDataEndpoints: APIEndpointProtocol {
    typealias Endpoint = Endpoints
    
    enum Endpoints: String {
        case reverse = "/geo/1.0/reverse"
    }
    
    func reverseGeocoding(queries: GeocodingQueries) -> APIRequest<EmptyBody, GeocodingQueries, EmptyHeaders, ReverseGeocodingResponse> {
        return .init(path: Endpoint.reverse.rawValue,queries: queries)
    }
}
