//
//  CityDataModel.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 23/08/21.
//

import Foundation

class AQIModel {
    var value: Float = 0.0
    var date: Date = Date()
    init(value: Float, date: Date) {
        self.value = value
        self.date = date
    }
}

protocol CityDataModel {
    var city: String { get set }
    var history: [AQIModel] { get set }
}

class CityDataModelData: CityDataModel {
    var city: String
    var history: [AQIModel] = [AQIModel]()
    
    init(city: String) {
        self.city = city
    }
}
