//
//  Covid19.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 22/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation
import UIKit

struct Covid19: Decodable {
    let id: Int
    let country: String
    let country_code: String
    let province: String?
    let last_updated: String
    let coordinates: Coordinates
    let latest_cases: LatestData?
    
    enum CodingKeys: String,CodingKey {
        case id
        case country
        case country_code
        case province
        case last_updated
        case coordinates
        case latest_cases = "latest"
    }
}

struct LatestData: Decodable {
    let confirmed: Int?
    let deaths: Int?
    let recovered: Int?
}


struct Coordinates: Decodable {
    let latitude: String
    let longitude: String
}
