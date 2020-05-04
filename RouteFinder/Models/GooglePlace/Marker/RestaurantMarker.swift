//
//  RestaurantMarker.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/4/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
import GoogleMaps

class RestaurantMarker: MarkerBase {
    let googlePlace: GooglePlace

    init(googlePlace: GooglePlace) {
        self.googlePlace = googlePlace
        let location = googlePlace.geometry.location
        super.init(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng))

        icon = UIImage(named: "restaurant_pin")
    }
}
