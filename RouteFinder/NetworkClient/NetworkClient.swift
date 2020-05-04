//
//  NetworkClient.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/3/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

struct NetworkClient {

    static func getDirection(origin: String,
                             destination: String,
                             completion: @escaping (_ directionResponse: DirectionResponse?, _ error: Error?) -> Void)  {
        let parameters = ["origin": origin,
                          "destination" : destination,
                          "departure_time" : "now",
                          "key" : GoogleAPI.generalKey]

        let urlRequest = "\(GoogleAPI.baseUrl)/maps/api/directions/json"

        AF.request(urlRequest, parameters: parameters).responseJSON { (request) in
            switch request.result {
            case .success:
                guard let data = request.data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(DirectionResponse.self, from: data)
                    completion(response, nil)
                } catch let parsingError {
                    return completion(nil, parsingError)
                }
            case .failure(let error):
                print(error)
                return completion(nil, error)
            }
        }
    }

    static func getRestaurantNearbyFromCoordinate(coordidate: CLLocationCoordinate2D,
                                                  radius: Double,
                                                  completion: @escaping (_ googlePlace: GooglePlaceResponse?, _ error: Error?) -> Void) {
        let parameters = ["location": "\(coordidate.latitude), \(coordidate.longitude)",
                          "radius": radius,
                          "rankby": "prominence",
                          "type": "restaurant",
                          "sensor": true,
                          "key": GoogleAPI.generalKey] as Parameters

        let urlRequest = "\(GoogleAPI.baseUrl)/maps/api/place/nearbysearch/json?"

        AF.request(urlRequest, parameters: parameters).responseJSON { (request) in
            switch request.result {
            case .success:
                guard let data = request.data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(GooglePlaceResponse.self, from: data)
                    completion(response, nil)
                } catch let parsingError {
                    return completion(nil, parsingError)
                }
            case .failure(let error):
                print(error)
                return completion(nil, error)
            }
        }
    }
}
