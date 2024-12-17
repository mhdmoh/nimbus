//
//  BaseRepository.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol BaseRepository {}

extension BaseRepository {
    func sendRequest<Response: Decodable>(
        call: () async ->  Result<Response, APIErrorModel>,
        offlineCall: (() async throws -> Response)? = nil, //todo:
        cacheCall  : ((Response) -> Void)? = nil
    ) async -> Result<Response, APIErrorModel> {
        let result = await call()
        switch result {
        case .success( let successResult):
            if let cacheCall {
                cacheCall(successResult)
            }
            return .success(successResult)
        case .failure(let error):
            return .failure(error)
        }
    }
}
