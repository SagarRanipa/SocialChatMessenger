//
//  LocationManager.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-09-07.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?

    
    private override init() {
        super.init()
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        
        if locationManager == nil {
            print("auth location manager")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        } else {
            print("we have location manager")
        }
    }
    
    func startUpdating() {
        locationManager!.startUpdatingLocation()
    }
        
    func stopupdating() {
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }
    }
        
    //MARK: - delegate
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to get location")
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            currentLocation = locations.last!.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .notDetermined {
            self.locationManager!.requestWhenInUseAuthorization()
        }
        
    }
}


