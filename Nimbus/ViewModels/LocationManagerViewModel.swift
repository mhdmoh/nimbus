//
//  LocationManager.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import CoreLocation
import CoreLocationUI

class LocationManagerViewModel: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    private let nimbusService: NimbusService

    @Published var locationName: String?
    @Published var location: CLLocationCoordinate2D? {
        didSet {
            guard location != nil else { return }
            Task{ await getLocationName() }
        }
    }
    
    init(service: NimbusService) {
        self.nimbusService = service
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func requestAuthorization(always: Bool = false) {
        always ? manager.requestAlwaysAuthorization() : manager.requestWhenInUseAuthorization()
    }
    
    func getLocationName() async {
        let result = await nimbusService.reverseGeocoding(queries: .init(latitude: location!.latitude, longitude: location!.longitude))
        switch result {
        case .success(let element):
            locationName = "\(element.country),\(element.name)"
        case .failure(let error):
            NLogger().log("Couldn't get the name of the location \(error)")
        }
    }
}

extension LocationManagerViewModel: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        NLogger().log("Error getting location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}
