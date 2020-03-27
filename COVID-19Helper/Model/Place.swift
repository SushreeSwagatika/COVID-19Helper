//
//  Place.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 23/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation

struct Place: Decodable {
    let geometry : Location
    let name : String
    let types : [String]
    let address : String
    
    enum CodingKeys : String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case types = "types"
        case address = "vicinity"
    }
}


