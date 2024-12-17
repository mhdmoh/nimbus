//
//  BaseResponse.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

struct BaseResponse<Item: Codable> : Codable {
    let data: Item?
    let statusCode: Int
    let messages: [String]
}
