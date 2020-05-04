//
//  Step.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/4/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation

struct Step: Codable {
    var distance: Distance
    var duration: Duration
    var startLocation: Location
    var endLocation: Location
    var polyline: Polyline
}
