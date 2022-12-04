//
//  LocationManager.swift
//  MapLocationRoot
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import Foundation
import CoreLocation
import MapKit

class CoreLocationManager: NSObject {
    
    static let shared = CoreLocationManager()
    
    var userLocation: CLLocation?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    func findUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            findUserLocation()
        case .restricted, .denied:
            NotificationCenter.default.post(name: NSNotification.Name("access-denied"), object: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            userLocation = location
    
            NotificationCenter.default.post(name: NSNotification.Name("did-update-location"), object: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AlertModel.shared.showAlert(title: "Error", descr: "Something went wrong. Please try again later", buttonText: "OK")
        IndicatorModel.loadingIndicator.dismiss(animated: true)
        print("Error occurred: \(error.localizedDescription)")
    }
}
