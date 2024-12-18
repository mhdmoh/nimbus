//
//  ForecastItemView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import SwiftUI
import Kingfisher

struct ForecastItemView: View {
    let item: ForecastItem
    
    var body: some View {
        VStack{
            Text(item.dtTxt.split(separator: " ")[1].prefix(5))
                .font(.footnote)
            
            KFImage.url(URL(string: item.weather[0].icon.icon())!)
                .resizable()
                .frame(
                    width:  40,
                    height: 40
                )
            
            Text(String(format: "%.1f \u{00B0}C", item.main.temp))
                .font(.footnote.bold())
        }
        .padding()
        .mainBackground()
    }
}

#Preview {
    ForecastItemView(
        item: ForecastItem.example
    )
}
