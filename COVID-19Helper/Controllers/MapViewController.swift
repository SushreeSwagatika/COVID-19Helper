//
//  MapViewController.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 22/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

typealias PlacesCompletion = (PlaceResponse?) -> Void

class MapViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var pinImageVerticalConstraint: NSLayoutConstraint!
    
    var locationHelper: LocationHelper!
    
    let Google_API_Key = "YOUR_GOOGLE_API_KEY"
    
    let locationTypes = ["hospital","drugstore","doctor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationHelper = LocationHelper()
        self.locationHelper.setMapViewSettings(for: mapView)
        mapView.delegate = self
        
        locationHelper.locationDelegate = self
    }
    
    func getAddressFrom(coordinate:CLLocationCoordinate2D) {
        self.locationHelper.reverseGeocode(coordinate: coordinate) { (address) in
            self.lblAddress.text = address
        }
    }
    
    func fetchPlacesNear(_ coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: @escaping PlacesCompletion) -> Void{
        types.forEach { (type) in
            var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&key=\(Google_API_Key)"
            let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
            urlString += "&types=\(typesString)"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
            
//            print(urlString)
            
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            let request = AF.request(url, method: .get)
            
            request.responseDecodable(of: PlaceResponse.self, completionHandler: { (response) in
//                guard let placeResponse = response.value! else { return }
                guard let placeResponse = response.value else { return }
                completion(placeResponse)
            })
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAddressFrom(coordinate: position.target)
        self.fetchPlacesNear(position.target, radius: 5000, types: locationTypes) { (placeResponse) in
            placeResponse?.places.forEach({ (place) in
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude))
                marker.icon = GMSMarker.markerImage(with: .green)
                marker.title = place.address
                marker.map = self.mapView
            })
        }
    }
}
// MARK:- location methods

extension MapViewController: LocationDelegate {
    func locationManager(didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print(location)
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
            self.mapView.camera = camera
            
            getAddressFrom(coordinate: location.coordinate)
        }
    }
    
    func locationManager(didFailWithError error: Error) {
        debugPrint(error)
    }    
}
