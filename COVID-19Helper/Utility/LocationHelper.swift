//
//  LocationHelper.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 22/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol LocationDelegate: class {
    func locationManager(didUpdateLocations locations: [CLLocation])
    func locationManager(didFailWithError error: Error)
}

class LocationHelper: NSObject , CLLocationManagerDelegate {
    
    public let locationManager: CLLocationManager?
    weak var locationDelegate: LocationDelegate?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    public func setMapViewSettings(for mapView:GMSMapView) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        } else {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    public func reverseGeocode(coordinate: CLLocationCoordinate2D, addressCompletion: @escaping (String)-> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
                else {
                    debugPrint(error?.localizedDescription ?? "Could not reverse geocode the coordinate")
                    return
            }
            
            let finalAddress =  lines.joined(separator: "\n")
            addressCompletion(finalAddress)
        }
    }
    
    
    // MARK:- location methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationDelegate?.locationManager(didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationDelegate?.locationManager(didFailWithError: error)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
    }
}


