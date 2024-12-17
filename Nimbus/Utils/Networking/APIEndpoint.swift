//
//  APIEndpoint.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol APIEndpointProtocol {
    associatedtype Endpoint: RawRepresentable where Endpoint.RawValue == String
}
