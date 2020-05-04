//
//  MarkerBase.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/4/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
import GoogleMaps

class MarkerBase: GMSMarker {
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        position = coordinate
        appearAnimation = .pop
        groundAnchor = CGPoint(x: 0.5, y: 1)
    }
}
