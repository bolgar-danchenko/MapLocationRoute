//
//  VisitedPlaces.swift
//  MapLocationRoot
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import Foundation
import MapKit

class VisitedPlaces: NSObject, MKAnnotation {
    
    static let shared = VisitedPlaces(title: "", coordinate: CLLocationCoordinate2D(), info: "")
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        
        super.init()
    }
}

extension VisitedPlaces {
    
    func make() -> [VisitedPlaces] {
        return [
            .init(title: "florence".localized,
                  coordinate: CLLocationCoordinate2D(latitude: 43.769562, longitude: 11.255814),
                  info: "leapOfFaith".localized),
            
            .init(title: "rome".localized,
                  coordinate: CLLocationCoordinate2D(latitude: 41.902782, longitude: 12.496366),
                  info: "goodPasta".localized),
            
            .init(title: "berlin".localized,
                  coordinate: CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954),
                  info: "ichBinEinBerliner".localized),
            
            .init(title: "luxembourg".localized,
                  coordinate: CLLocationCoordinate2D(latitude: 49.611622, longitude: 6.131935),
                  info: "veryNiceCity".localized),
            
            .init(title: "zurich".localized,
                  coordinate: CLLocationCoordinate2D(latitude: 47.373878, longitude: 8.545094),
                  info: "flamingosWalkingAround".localized),
        ]
    }
}
