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
    
    let allStrings = AllStrings()
    
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
            .init(title: allStrings.florenceTitle, coordinate: CLLocationCoordinate2D(latitude: 43.769562, longitude: 11.255814), info: allStrings.florenceInfo),
            .init(title: allStrings.romeTitle, coordinate: CLLocationCoordinate2D(latitude: 41.902782, longitude: 12.496366), info: allStrings.romeInfo),
            .init(title: allStrings.berlinTitle, coordinate: CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954), info: allStrings.berlinInfo),
            .init(title: allStrings.luxembourgTitle, coordinate: CLLocationCoordinate2D(latitude: 49.611622, longitude: 6.131935), info: allStrings.luxembourgInfo),
            .init(title: allStrings.zurichTitle, coordinate: CLLocationCoordinate2D(latitude: 47.373878, longitude: 8.545094), info: allStrings.zurichInfo),
        ]
    }
}
