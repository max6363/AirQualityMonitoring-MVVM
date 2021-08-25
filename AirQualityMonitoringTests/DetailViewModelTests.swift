//
//  DetailViewModelTests.swift
//  AirQualityMonitoringTests
//
//  Created by minhazpanara on 25/08/21.
//

import XCTest
import RxSwift
import RxNimble
import Nimble

@testable import AirQualityMonitoring

//// MARK: tests fake data
let fakeResponseForDetails: [AQIResponseData] = [AQIResponseData(city: "Delhi", aqi: 200.0)]
let fakeDataProviderForDetails: DataProvider = FakeDataProvider(fakeResponse: .success(fakeResponseForDetails))

let fakeDataProviderForDetailsWithError: DataProvider
    = FakeDataProvider(fakeResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))

class DetailViewModelTests: XCTestCase {

    let detailViewModel: DetailViewModel = DetailViewModel(dataProvider: fakeDataProviderForDetails)
    
    let detailViewModelError: DetailViewModel = DetailViewModel(dataProvider: fakeDataProviderForDetailsWithError)
    
    func testRespnoseDataInformation() {
        
        detailViewModel.subscribe(forCity: "Delhi")
        
        expect(self.detailViewModel.prevItem?.city) == fakeResponse.first?.city
        expect(self.detailViewModel.prevItem?.history.last?.value) == fakeResponse.first?.aqi
        
        detailViewModel.unsubscribe()
    }
    
    func testDataInformationWhenPrevItemsAvailable() {
        
        let item = CityDataModelData(city: "Mumbai")
        item.history = [AQIModel(value: 100, date: Date())]
        detailViewModel.prevItem = item
     
        detailViewModel.subscribe(forCity: "Mumbai")
        
        expect(self.detailViewModel.prevItem?.city) == "Mumbai"
        expect(self.detailViewModel.prevItem?.history.last?.value) == 100
        
        detailViewModel.unsubscribe()
    }
 
    func testErrorResponse() {
        
        detailViewModelError.subscribe(forCity: "Delhi")
        
        let p = self.detailViewModelError.prevItem
        expect(p) == nil
        
    }
}
