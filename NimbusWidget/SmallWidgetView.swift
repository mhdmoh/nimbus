//
//  SmallWidgetView.swift
//  NimbusWidgetExtension
//
//  Created by Mohamad Mohamad on 22/12/2024.
//

import SwiftUI
import Kingfisher

struct SmallWidgetView : View {
    var entry: WeatherEntry
    
    var body: some View {
        VStack(spacing: 4){
            HStack{
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(.blue)
                
                Text("\(entry.weather.sys.country!), \(entry.weather.name)")
                    .font(.system(size: 10))
                
                Spacer()
            }
            .padding(.bottom, 2)
            
            HStack{
                KFImage(URL(string: entry.weather.weather.first!.icon.icon()))
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(
                        width: 32,
                        height: 32
                    )
                
                    .padding(3)
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.15))
                    }
                
                
                
                Text(String(format: "%.2f\u{00B0}C", entry.weather.main.temp))
                
                Spacer()
            }
            .font(.title3)
            .padding(.top, 2)
            
            Text(entry.weather.weather.first!.main)
                .font(.title)
            
            HStack(spacing: 1){
                Text("H:")
                    .foregroundStyle(.blue)
                
                Text(String(format: "%.2f\u{00B0}, ", entry.weather.main.tempMax))
                
                Text("L:")
                    .foregroundStyle(.blue)
                
                Text(String(format: "%.2f\u{00B0}", entry.weather.main.tempMin))
            }
            .font(.footnote)
        }
    }
}
