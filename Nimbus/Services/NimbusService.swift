//
//  NimbusService.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import Foundation

protocol NimbusServiceProtocol {
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel>
}

struct NimbusService: NimbusServiceProtocol {
    private let repo: NimbusRepoProtocol
    
    init(repo: NimbusRepoProtocol) {
        self.repo = repo
    }
    
    func currentWeather(_ queries: WeatherQueries) async -> Result<CurrentWeather, APIErrorModel> {
        return await repo.currentWeather(queries)
    }
}
