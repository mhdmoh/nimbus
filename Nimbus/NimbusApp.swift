//
//  NimbusApp.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI
import Swinject

extension EnvironmentValues {
    @Entry var container = Container()
    
    var nimbusService: NimbusService {
        return self.container.resolve(NimbusService.self)!
    }
}


extension Container {
    
    static func setupDependencies() -> Container {
        var container = Container()
        container.register(APIClient.self) { _ in
            return APIClient()
        }
        
        container.registerEndpoints()
        
        container.register(NimbusDS.self) { resolver in
            return NimbusDS(
                client: resolver.resolve(APIClient.self)!,
                weatherDataEndpoint: resolver.resolve(WeatherDataEndpoints.self)!,
                geoDataEndpoint: resolver.resolve(GeoDataEndpoints.self)!
            )
        }
        
        container.register(NimbusRepo.self) { resolver in
            return NimbusRepo(remoteDS: resolver.resolve(NimbusDS.self)!)
        }
        
        container.register(NimbusService.self) { resolver in
            return NimbusService(repo: resolver.resolve(NimbusRepo.self)!)
        }
        
        return container
    }
    
    static func setupMockDependencies() -> Container {
        return Container.setupDependencies()
    }
    
    private func registerEndpoints() {
        self.register(WeatherDataEndpoints.self) { _ in
            return WeatherDataEndpoints()
        }
        
        self.register(GeoDataEndpoints.self) { _ in
            return GeoDataEndpoints()
        }
    }
}

@main
struct NimbusApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.container, Container.setupDependencies())
        }
    }
}
