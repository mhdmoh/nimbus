//
//  WeatherForecastViewModel.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import Foundation
import CoreLocation

enum ForecastTypes: String, CaseIterable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case next3Days = "Next 3 days"
}

@MainActor
class WeatherForecastViewModel: ObservableObject {
    // MARK: - Properties
    private let service: NimbusService
    
    @Published var forecast: [ForecastItem]?
    @Published var weeklyForecast: [Int: [ForecastItem]]?
    @Published var selectedForecastType: ForecastTypes = .today {
        didSet{ updateForecast() }
    }
    
    // MARK: - Initializer
    init(service: NimbusService) {
        self.service = service
    }
    
    
    // MARK: - Public Methods
    func fetchForecast(location: CLLocationCoordinate2D) async {
        let result = await self.service.weatherForecast(.init(latitude: location.latitude, longitude: location.longitude))
        switch result {
        case .success(let forecast):
            processForecastData(forecast.list)
        case .failure(let error):
            NLogger().log("Error getting the weather forecast: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    private func processForecastData(_ forecastList: [ForecastItem]) {
        let grouped = Dictionary(grouping: forecastList) { item in
            parseDate(item.dtTxt)
        }
        .compactMapValues { $0 }
        
        weeklyForecast = grouped.sorted { $0.key < $1.key }
            .reduce(into: [:]) { $0[$1.key] = $1.value }
        
        updateForecast()
    }
    
    private func parseDate(_ dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = formatter.date(from: dateString) else {
            NLogger().log("Failed to parse date: \(dateString)")
            return -1
        }
        
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    private func updateForecast() {
        if weeklyForecast == nil { return }
        switch selectedForecastType {
        case .today:
            forecast = weeklyForecast!.first?.value
        case .tomorrow:
            forecast = weeklyForecast![weeklyForecast!.keys.compactMap{ $0 }[1]]
        case .next3Days:
            forecast = weeklyForecast!.dropFirst(2).flatMap{$0.value}
        }
    }
}
