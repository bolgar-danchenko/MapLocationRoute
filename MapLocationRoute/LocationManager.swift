//
//  LocationManager.swift
//  MapLocationRoot
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import Foundation
import CoreLocation

class LocationManager {
    
    static let shared = LocationManager()
    
    func getCoordinates(with address: String) -> CLLocationCoordinate2D {
        
        let geoCoder = CLGeocoder()
        
        var coordinates = CLLocationCoordinate2D()
        
        geoCoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                return
            }
            coordinates = location
        }
        return coordinates
    }
}
