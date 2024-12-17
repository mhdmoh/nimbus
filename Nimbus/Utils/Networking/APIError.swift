//
//  APIError.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse(error: Error)
    case invalidContentType
}
