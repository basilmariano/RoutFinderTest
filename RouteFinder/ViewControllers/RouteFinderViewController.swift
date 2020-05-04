//
//  RouteFinderViewController.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/3/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import UIKit
import GoogleMaps

class RouteFinderViewController: UIViewController {

    @IBOutlet private weak var mapView: GMSMapView! {
        didSet {
            mapView.delegate = self
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }

    @IBOutlet private weak var driveButton: UIButton!
    @IBOutlet private weak var overviewButton: UIButton!

    private let locationManager = CLLocationManager()
    private var route: Route?
    private var isDriving = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }

        //We can also use lat and lon here if needed
        getDirectionFromGoogle(origin: "Riga, Latvia", destination: "Estonia")
    }

    // MARK: IBActions
    @IBAction private func didTapOverView() {
        if isDriving {
            stopDriving()
        } else {
            locationManager.stopUpdatingLocation()
        }
        showOverView()
    }

    @IBAction private func didTapStart() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse &&
            CLLocationManager.authorizationStatus() != .authorizedAlways {
            return
        }

        if isDriving {
            stopDriving()
        } else {
            resumeDriving()
        }
    }

    // MARK: Private Functions
    private func getDirectionFromGoogle(origin: String, destination: String) {
        NetworkClient.getDirection(origin: origin,
                                   destination: destination) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }

            if let error = error  {
                strongSelf.showAlert(message: error.localizedDescription)
                return
            }

            if let response = response {
                if let route = response.routes.first {
                    strongSelf.route = route
                    for leg in route.legs {
                        //Show Point A
                        if let firstStep = leg.steps.first {
                            let coor = CLLocationCoordinate2D(latitude: firstStep.startLocation.lat,
                                                              longitude: firstStep.startLocation.lng)
                            let marker = StartMarker(coordinate: coor)
                            marker.map = self?.mapView
                        }
                        //Show Point A
                        if let lastStep = leg.steps.last {
                            let coor = CLLocationCoordinate2D(latitude: lastStep.endLocation.lat,
                                                              longitude: lastStep.endLocation.lng)
                            let marker = FinishMarker(coordinate: coor)
                            marker.map = self?.mapView
                        }

                        //Draw the routes
                        leg.steps.forEach { (step) in
                            strongSelf.drawDirectionsFromPath(encodedPath: step.polyline.points)
                            let endLocationCoor = CLLocationCoordinate2D(latitude: step.endLocation.lat,
                                                                         longitude: step.endLocation.lng)
                            strongSelf.showRestaurantFroCoordinate(coordinate: endLocationCoor, radius: 300)
                        }
                    }
                }
            }
        }
    }

    private func drawDirectionsFromPath(encodedPath: String) {
        if let path = GMSPath(fromEncodedPath: encodedPath) {
            let polyline = GMSPolyline(path: path)

            polyline.strokeWidth = 4
            polyline.map = mapView
        }
    }

    private func showOverView() {
        guard let route = self.route else { return }

        if let path = GMSPath(fromEncodedPath: route.overviewPolyline.points) {
            let polyline = GMSPolyline(path: path)
            if let polyPath = polyline.path {
                mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path:polyPath),
                           withPadding: 100))
            }
        }
    }

    private func showRestaurantFroCoordinate(coordinate: CLLocationCoordinate2D, radius: Double) {
        NetworkClient.getRestaurantNearbyFromCoordinate(coordidate: coordinate, radius: radius) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }

            if let error = error  {
                strongSelf.showAlert(message: error.localizedDescription)
                return
            }

            if let response = response {
                let maxRestaurantCount = 10
                let first10 = response.results.prefix(maxRestaurantCount)
                first10.forEach { (place) in
                    let marker = RestaurantMarker(googlePlace: place)
                    marker.map = self?.mapView
                }
            }
        }
    }

    private func stopDriving() {
        isDriving = false
        locationManager.stopUpdatingLocation()
        driveButton.setTitle(Text.resume, for: .normal)
        driveButton.backgroundColor = UIColor.green
    }

    private func resumeDriving() {
        isDriving = true
        locationManager.startUpdatingLocation()
        driveButton.setTitle(Text.stop, for: .normal)
        driveButton.backgroundColor = UIColor.red
    }

}

// MARK: - CLLocationManagerDelegate
extension RouteFinderViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    guard status == .authorizedWhenInUse else {
      return
    }

    locationManager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: 16, bearing: location.course, viewingAngle: 45)

    mapView?.animate(to: camera)
  }

}

// MARK: - GMSMapViewDelegate
extension RouteFinderViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
          mapView.selectedMarker = nil
        }
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
      mapView.selectedMarker = nil
      return false
    }

    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let marker = marker as? RestaurantMarker else {
            return nil
        }

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = marker.googlePlace.name
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)

        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            view.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: -5),
            view.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5)
        ]
        NSLayoutConstraint.activate(constraints)


        return view
    }
}
