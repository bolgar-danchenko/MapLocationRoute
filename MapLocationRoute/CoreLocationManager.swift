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
    
    func getDistance(route: MKRoute) -> String {
        
        let distance = Int(route.distance/1000)
        let localizedString = NSLocalizedString("routeDistance", comment: "")
        let formattedString = String(format: localizedString, distance)
        
        return formattedString
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (_ route: MKRoute?) -> Void) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            
            guard let unwrappedResponse = response else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            guard let route = unwrappedResponse.routes.first else {
                completion(nil)
                return
            }
            completion(route)
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
        AlertModel.shared.showAlert(title: "attention".localized,
                                    descr: "locationErrorDescr".localized,
                                    buttonText: "ok".localized)
        IndicatorModel.loadingIndicator.dismiss(animated: true)
        print("Error occurred: \(error.localizedDescription)")
    }
}
