//
//  FBPlace.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/5/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation

struct FBPlace: Codable {
    var id: String
    var engagement: Engagement
    var name: String
    var location: FBLocation
}
