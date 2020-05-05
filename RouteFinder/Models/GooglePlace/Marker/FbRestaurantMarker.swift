//
//  FbRestaurantMarker.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/5/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
import GoogleMaps

class FbRestaurantMarker: MarkerBase {
    let fbPlace: FBPlace

    init(fbPlace: FBPlace) {
        self.fbPlace = fbPlace
        let location = fbPlace.location

        super.init(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))

        icon = UIImage(named: "restaurant_pin")
    }
}
