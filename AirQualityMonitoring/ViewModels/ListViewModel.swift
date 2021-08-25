//
//  CityAQIDataViewModel.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 23/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListViewModel {
    
    var prevItems: [CityDataModelData] = [CityDataModelData]()
    
    var items = PublishSubject<[CityDataModelData]>()
    
    var provider: DataProvider?
    
    init(dataProvider: DataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    
    func subscribe() {
        provider?.subscribe()
    }
    
    func unsubscribe() {
        provider?.unsubscribe()
    }
}

extension ListViewModel: DataProviderDelegate {
    func didReceive(response: Result<[AQIResponseData], Error>) {
        switch response {
        
        case .success(let response):
            parseAndNotify(resArray: response)
        
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func parseAndNotify(resArray: [AQIResponseData]) {
        
        if prevItems.count == 0 {
            for d in resArray {
                let m = CityDataModelData(city: d.city)
                m.history.append(AQIModel(value: d.aqi, date: Date()))
                prevItems.append(m)
            }
        } else {
        
            for res in resArray {
                let matchedResults = prevItems.filter { $0.city == res.city }
                if let matchedRes = matchedResults.first {
                    matchedRes.history.append(AQIModel(value: res.aqi, date: Date()))
                } else {
                    let m = CityDataModelData(city: res.city)
                    m.history.append(AQIModel(value: res.aqi, date: Date()))
                    prevItems.append(m)
                }
            }
        }
                                                        
        items.onNext(prevItems)
    }
    
    func handleError(error: Error?) {
        if let e = error {
            items.onError(e)
        }
    }
}
