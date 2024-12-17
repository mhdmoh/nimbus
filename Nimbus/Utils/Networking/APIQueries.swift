//
//  APIQueries.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol APIQueriesProtocol {
    func getQueries() -> [URLQueryItem]
}

struct EmptyQueries: APIQueriesProtocol {
    func getQueries() -> [URLQueryItem] {
        []
    }
}
