//
//  APIHeaders.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation
protocol APIHeadersProtocol {
    var isAuth: Bool { get }
    var headers : [String: String] { get set }
    
    func getHeaders() -> [String: String]
}

extension APIHeadersProtocol {
    func getHeaders() -> [String : String] {
        return headers
    }
}

struct AuthorizedHeaders: APIHeadersProtocol {
    var headers : [String: String]
    var isAuth: Bool = true
    
    init(headers: [String : String] = [:]) {
        self.headers = headers
    }
}

struct APIHeaders: APIHeadersProtocol {
    var headers : [String: String]
    var isAuth: Bool = false
    
    init(headers: [String : String]) {
        self.headers = headers
    }
}

struct EmptyHeaders: APIHeadersProtocol {
    var isAuth: Bool = false
    var headers : [String: String] = [:]
}
