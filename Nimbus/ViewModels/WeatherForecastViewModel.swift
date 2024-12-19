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
    private let service: NimbusService
    
    
    
    @Published var forecast: [ForecastItem]?
    @Published var weeklyForecast: [Int: [ForecastItem]]?
    
    @Published var selectedForecastType: ForecastTypes = .today {
        didSet{
            setForecast()
        }
    }
    
    init(service: NimbusService) {
        self.service = service
    }
    
    func setForecast() {
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
    
    func forecast(location: CLLocationCoordinate2D) async {
        let result = await self.service.weatherForecast(.init(latitude: location.latitude, longitude: location.longitude))
        switch result {
        case .success(let forecast):
            let grouped = Dictionary(grouping: forecast.list) { item in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: item.dtTxt)!
                return Int(date.formatted().split(separator: "/")[0])!
            }
            
            weeklyForecast = Dictionary(uniqueKeysWithValues: grouped.sorted { $0.key < $1.key })
            setForecast()
            
        case .failure(let error):
            NLogger().log("Error getting the weather forecast: \(error.localizedDescription)")
        }
    }
}
