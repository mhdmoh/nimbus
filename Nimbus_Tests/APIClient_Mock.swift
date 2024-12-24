//
//  APIClient_Mock.swift
//  Nimbus_Tests
//
//  Created by Mohamad Mohamad on 24/12/2024.
//

import Foundation
@testable import Nimbus

class MockAPIClient: APIClientProtocol {
    var resultToReturn: Any?
    var errorToReturn: APIErrorModel?
    
    func request<Request>(
        using request: Request,
        body: Request.Body? = nil,
        headers: Request.Headers? = nil
    ) async -> Result<Request.Response, APIErrorModel> where Request : APIRequestProtocol {
        if let error = errorToReturn {
            return .failure(error)
        }
        
        if let result = resultToReturn as? Request.Response {
            return .success(result)
        }
        
        // Return a failure if no predefined result or error was set
        return .failure(APIErrorModel(message: "Unknown error"))
    }
}
