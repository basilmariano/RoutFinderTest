//
//  Leg.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/3/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation

struct Leg: Codable {
    var distance: Distance
    var duration: Duration
    var steps: [Step]
}
