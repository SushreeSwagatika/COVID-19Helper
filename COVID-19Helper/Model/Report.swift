//
//  Report.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 22/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation

struct Report: Decodable {
    let latest_cases: LatestData?
    let locations: [Covid19]

    enum CodingKeys: String, CodingKey {
        case latest_cases = "latest"
        case locations
    }
}
