//
//  ContentView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: CurrentWeatherViewModel
    
    init() {
        _viewModel = StateObject(
            wrappedValue: CurrentWeatherViewModel(
                service: NimbusService(
                    repo: NimbusRepo(
                        remoteDS: NimbusDS(
                            client: APIClient(),
                            endpoint: NimbusEndpoints()
                        )
                    )
                )
            )
        )
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            Task {
                await viewModel.fetchCurrentWeather()
            }
        }
    }
}

#Preview {
    ContentView()
}
