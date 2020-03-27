//
//  Location.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 23/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation

struct Location: Decodable {
    let location: CoordinateLatLng
    
    enum CodingKeys: String, CodingKey {
        case location 
    }
}
