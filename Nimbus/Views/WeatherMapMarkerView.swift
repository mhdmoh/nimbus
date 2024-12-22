//
//  WeatherMapMarkerView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 22/12/2024.
//

import SwiftUI
import Kingfisher

struct WeatherMapMarkerView: View {
    let weather: WeatherEntity
    
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing: 0) {
                KFImage(URL(string: weather.icon!.icon()))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: 6)
                
                HStack{
                    Spacer()
                    
                    Text(String(format: "%.2f \u{00B0}C", weather.lastKnownWeather!))
                        .font(.system(size: 12))
                        .foregroundStyle(Color.background)
                    
                    Spacer()
                }
                .padding(.vertical, 2)
                .background{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.blue.opacity(0.8))
                }
            }
            .padding(8)
            .background{
                RoundedRectangle(cornerRadius: 16)
                    .fill(.secondary.opacity(0.6))
            }
            
            Text(weather.weatherDescription!.capitalized)
                .font(.system(size: 10).bold())
                .padding(.vertical, 8)
        }
        .frame(
            width: 100, height: 100
        )
    }
}

#Preview {
    WeatherMapMarkerView(
        weather: .init(weather: .example)
    )
}
