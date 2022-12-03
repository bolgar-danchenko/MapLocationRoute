//
//  VisitedPlaces.swift
//  MapLocationRoot
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import Foundation
import MapKit

final class VisitedPlaces: NSObject, MKAnnotation {
    
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
    
    static func make() -> [VisitedPlaces] {
        return [
            .init(title: "Florence", coordinate: CLLocationCoordinate2D(latitude: 43.769562, longitude: 11.255814), info: "Leap of faith"),
            .init(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.902782, longitude: 12.496366), info: "Good pasta"),
            .init(title: "Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954), info: "Ich bin ein Berliner"),
            .init(title: "Luxembourg", coordinate: CLLocationCoordinate2D(latitude: 49.611622, longitude: 6.131935), info: "Very nice city"),
            .init(title: "Zurich", coordinate: CLLocationCoordinate2D(latitude: 47.373878, longitude: 8.545094), info: "Flamingos walking around"),
        ]
    }
}
