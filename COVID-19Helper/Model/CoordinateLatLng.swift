//
//  CoordinateLatLng.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 23/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation

struct CoordinateLatLng: Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys : String, CodingKey {
          case latitude = "lat"
          case longitude = "lng"
    }
}
