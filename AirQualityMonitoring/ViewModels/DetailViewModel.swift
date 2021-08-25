//
//  DetailViewModel.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 24/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import Starscream

class DetailViewModel {
    
    private var city: String = ""
    
    var prevItem: CityDataModelData? = nil
    
    var item = PublishSubject<CityDataModelData>()
    
    var provider: DataProvider?
    
    init(dataProvider: DataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    
    func subscribe(forCity: String) {
        self.city = forCity
        provider?.subscribe()
    }
    func unsubscribe() {
        provider?.unsubscribe()
    }
}

extension DetailViewModel: DataProviderDelegate {
    func didReceive(response: Result<[AQIResponseData], Error>) {
        switch response {
        
        case .success(let response):
            parseAndNotify(resArray: response)
        
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func parseAndNotify(resArray: [AQIResponseData]) {
        
        let cityData = resArray.filter { $0.city == city }
        if let data = cityData.first {
            if let prev = prevItem {
                prev.history.append(AQIModel(value: data.aqi, date: Date()))
            } else {
                prevItem = CityDataModelData(city: self.city)
                prevItem?.history.append(AQIModel(value: data.aqi, date: Date()))
            }
        } else {
            if let prev = prevItem, let last = prev.history.last {
                prev.history.append(last)
            }
        }
    
        if let p = prevItem {
            item.onNext(p)
        }
    }
    
    func handleError(error: Error?) {
        if let e = error {
            item.onError(e)
        }
    }
}
