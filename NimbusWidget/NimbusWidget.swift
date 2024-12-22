//
//  NimbusWidget.swift
//  NimbusWidget
//
//  Created by Mohamad Mohamad on 21/12/2024.
//

import WidgetKit
import SwiftUI
import Kingfisher
import CoreLocation


struct Provider: TimelineProvider {
    let service: NimbusService
    var lm = WidgetLocationManager()
    init() {
        service = NimbusService(repo: NimbusRepo(remoteDS: NimbusDS(client: APIClient(), weatherDataEndpoint: WeatherDataEndpoints(), geoDataEndpoint: GeoDataEndpoints())))
    }
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), weather: CurrentWeather.example)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(),  weather: CurrentWeather.example)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
        lm.fetchLocation { curLoc in
            Task {
                var entry: WeatherEntry? = nil
                let result = await service.currentWeather(WeatherQueries(latitude: curLoc.coordinate.latitude, longitude: curLoc.coordinate.longitude))
                switch result {
                case .success(let weather):
                    entry = WeatherEntry(date: .now, weather: weather)
                case .failure(_):
                    entry = WeatherEntry(date: .now,  weather: CurrentWeather.example)
                }
                let timeline = Timeline(entries: [entry!] , policy: .after(.now.advanced(by: 30 * 60)))
                completion(timeline)
            }
        }
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let weather: CurrentWeather
}

struct NimbusWidgetEntryView : View {
    var entry: WeatherEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            fatalError("This family type is not supported")
        }
    }
}

struct NimbusWidget: Widget {
    let kind: String = "NimbusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                NimbusWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                NimbusWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Weather Snapshot")
        .description("Displays the current weather conditions and temperature for your location.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    NimbusWidget()
} timeline: {
    WeatherEntry(date: .now, weather: .example)
}
