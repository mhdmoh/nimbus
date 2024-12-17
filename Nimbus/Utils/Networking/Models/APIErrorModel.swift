//
//  APIErrorModel.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

class APIErrorModel: Codable, Error {
    let statusCode: Int
    let messages: [String]
        
    init(statusCode: Int, messages: [String]){
        self.statusCode = statusCode
        self.messages = messages
    }
    
    convenience init() {
        self.init(statusCode: -1, messages: ["Something went wrong"])
    }
    
    convenience init(message: String) {
        self.init(statusCode: -1, messages: [message])
    }
    
}

