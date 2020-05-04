//
//  FinishMarket.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/4/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
import GoogleMaps

class FinishMarker: MarkerBase {
   override init(coordinate: CLLocationCoordinate2D) {
    super.init(coordinate: coordinate)
       icon = UIImage(named: "end_pin")
   }
}
