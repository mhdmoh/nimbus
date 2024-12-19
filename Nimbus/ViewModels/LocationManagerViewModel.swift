//
//  LocationManager.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import CoreLocation
import CoreLocationUI

class LocationManagerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let nimbusService: NimbusService
    
    @Published var location: CLLocationCoordinate2D? {
        didSet {
            if location != nil {
                Task{
                    await getLocationName()
                }
            }
        }
    }
    @Published var locationName: String?
    
    init(service: NimbusService) {
        self.nimbusService = service
    }
    
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func requestAuthorization(always: Bool = false) {
        manager.delegate = self
        
        if always {
            self.manager.requestAlwaysAuthorization()
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
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
