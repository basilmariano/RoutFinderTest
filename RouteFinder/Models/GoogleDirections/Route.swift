//
//  Route.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/3/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation

struct Route: Codable {
    var overviewPolyline: Polyline
    var legs: [Leg]
    var summary: String
}
