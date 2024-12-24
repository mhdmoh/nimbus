//
//  NimbusApp.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 17/12/2024.
//

import SwiftUI
import Swinject
import SwiftData

extension EnvironmentValues {
    @Entry var container = Container()
    
    var nimbusService: NimbusServiceProtocol {
        return self.container.resolve(NimbusServiceProtocol.self)!
    }
}


extension Container {
    
    static func setupDependencies() -> Container {
        let container = Container()
        container.register(APIClientProtocol.self) { _ in
            return APIClient()
        }
        
        container.registerEndpoints()
        
        container.register(NimbusDSProtocol.self) { resolver in
            return NimbusDS(
                client: resolver.resolve(APIClientProtocol.self)!,
                weatherDataEndpoint: resolver.resolve(WeatherDataEndpoints.self)!,
                geoDataEndpoint: resolver.resolve(GeoDataEndpoints.self)!
            )
        }
        
        container.register(ModelContainer.self) { _ in
            return try! ModelContainer(for: WeatherEntity.self)
        }
        
        container.register(NimbusRepoProtocol.self) { resolver in
            return NimbusRepo(remoteDS: resolver.resolve(NimbusDSProtocol.self)!, container: resolver.resolve(ModelContainer.self)!)
        }
        
        container.register(NimbusServiceProtocol.self) { resolver in
            return NimbusService(repo: resolver.resolve(NimbusRepoProtocol.self)!)
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
        .modelContainer(for: WeatherEntity.self)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
