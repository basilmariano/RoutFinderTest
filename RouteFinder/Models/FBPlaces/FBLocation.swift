//
//  FBLocation.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/5/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
struct FBLocation: Codable {
    var city: String
    var country: String
    var latitude: Double
    var longitude: Double
    var street: String?
}
