//
//  CurrentWeatherView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import SwiftUI
import Kingfisher

struct CurrentWeatherView: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    
                    Text(Date.now.formatted(.dateTime.day().month(.wide).year()))
                        .font(.caption)
                    
                    Text(weather.weather[0].description)
                        .font(.body.bold())
                    
                    VGap(space: 24)
                    
                    Text(String(format: "%.2f \u{00B0}C", weather.main.temp))
                        .font(.largeTitle.bold())
                }
                
                Spacer()
                
                KFImage.url(URL(string: weather.weather[0].icon.icon())!)
            }
            .padding()
            .mainBackground()
            
            VGap(space: 32)
            
            HStack{
                VStack {
                    Image(.fastWind)
                        .renderingMode(.template)
                        .foregroundStyle(.foreground)
                    
                    VGap(space: 12)
                    
                    Text(String(format: "%.2f m/s", weather.wind.speed))
                        .fontWeight(.bold)
                    
                    Text("Wind")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Image(.humidity)
                        .renderingMode(.template)
                        .foregroundStyle(.foreground)
                    
                    VGap(space: 12)
                    
                    Text("\(weather.main.humidity)%")
                        .fontWeight(.bold)
                    
                    Text("Humidity")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Image(.clouds)
                        .renderingMode(.template)
                        .foregroundStyle(.foreground)
                    
                    VGap(space: 12)
                    
                    Text("\(weather.clouds.all)")
                        .fontWeight(.bold)
                    
                    Text("Clouds")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .mainBackground()
        }
    }
}

#Preview {
    CurrentWeatherView(
        weather: CurrentWeather.example
    )
    .padding()
}
