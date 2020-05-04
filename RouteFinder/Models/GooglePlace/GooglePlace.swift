//
//  GooglePlace.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/4/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation

struct GooglePlace: Codable {
    var id: String
    var icon: String
    var name: String
    var placeId: String
    var vicinity: String
    var geometry: Geometry
}
