//
//  AQIResponseData.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 23/08/21.
//

import Foundation

struct AQIResponseData: Codable {
    var city: String
    var aqi: Float
    init(city: String, aqi: Float) {
        self.city = city
        self.aqi = aqi
    }
}
