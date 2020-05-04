//
//  GooglePlaceResponse.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/4/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation

struct GooglePlaceResponse: Codable {
    var results: [GooglePlace]
    var status: String
}
