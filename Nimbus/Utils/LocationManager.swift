//
//  LocationManager.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    public func requestAuthorization(always: Bool = false) {
        if always {
            self.manager.requestAlwaysAuthorization()
        } else {
            self.manager.requestWhenInUseAuthorization()
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
