//
//  APIClient.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol APIClientProtocol {
    func request<Request: APIRequestProtocol> (
        using request: Request,
        body: Request.Body?,
        headers: Request.Headers?
    ) async -> Result<Request.Response, APIErrorModel>
}

extension APIClientProtocol {
    func request<Request>(
        using request: Request
    ) async -> Result<Request.Response, APIErrorModel> where Request : APIRequestProtocol, Request.Body == EmptyBody, Request.Headers == EmptyHeaders {
        return await self.request(using: request, body: nil , headers: nil)
    }
}


struct APIClient: APIClientProtocol {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func setContentType(for request: inout URLRequest, contentType: ContentType) {
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }
    
    func request<Request>(
        using request: Request,
        body: Request.Body? = nil,
        headers: Request.Headers? = nil
    ) async -> Result<Request.Response, APIErrorModel> where Request : APIRequestProtocol {
        guard let url = request.createURL() else {
            return .failure(.init(message: APIError.invalidURL.localizedDescription))
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let headers = headers {
            urlRequest.allHTTPHeaderFields = headers.getHeaders()
        }
        
        urlRequest.httpMethod = request.method.rawValue
        NLogger.shared.log("Response Status Code: \(String(describing: urlRequest.url))", level: .info)

        let session = URLSession.shared
        do{
            if Request.Body.self != EmptyBody.self {
                switch request.contentType {
                case .json:
                    urlRequest.httpBody = try encoder.encode(body)
                    setContentType(for: &urlRequest, contentType: request.contentType)
                    NLogger().log(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "NO Body")
                case .multipart:
                    return .failure(.init(message: APIError.invalidContentType.localizedDescription))
                }
            }
            
            let (data, response) = try await session.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse {
                NLogger.shared.log("Response Status Code: \(httpResponse.statusCode)", level: .info)
            }
            guard (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? -1) else {
                let errorResponse = String(data: data, encoding: .utf8) ?? "Unknown error response"
                NLogger.shared.log("Server Error: \(errorResponse)", level: .error)
                
                var result: APIErrorModel? = nil
                do{
                    result = try await Task.detached {
                        try decoder.decode(APIErrorModel.self, from: data)
                    }.value
                }catch{
                    NLogger.shared.log("Couldn't decode error response", level: .error)
                }
                return .failure(result ?? .init())
            }
            NLogger().log(String(data: data, encoding: .utf8) ?? "", level: .debug)
            let result = try await Task.detached {
                try decoder.decode(Request.Response.self, from: data)
            }.value
            
            return .success(result)
        }catch {
            print(error)
            return .failure(.init(message: error.localizedDescription))
        }
    }
}
