//
//  PlaceResponse.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 23/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation

struct PlaceResponse: Decodable {
    let places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case places = "results"
    }
}


