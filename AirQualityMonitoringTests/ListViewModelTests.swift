//
//  ListViewModelTest.swift
//  AirQualityMonitoringTests
//
//  Created by minhazpanara on 25/08/21.
//

import XCTest
import RxSwift
import RxNimble
import Nimble

@testable import AirQualityMonitoring

// MARK: tests fake data (success)
let fakeResponse: [AQIResponseData] = [AQIResponseData(city: "Delhi", aqi: 200.0)]
let fakeDataProvider: DataProvider = FakeDataProvider(fakeResponse: .success(fakeResponse))

let fakeDataProviderError: DataProvider
    = FakeDataProvider(fakeResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))

class ListViewModelTests: XCTestCase {

    let listViewModel: ListViewModel = ListViewModel(dataProvider: fakeDataProvider)
    
    let listViewModelError: ListViewModel = ListViewModel(dataProvider: fakeDataProviderError)
    
    func testRespnoseDataInformation() {
        
        listViewModel.subscribe()
        
        expect(self.listViewModel.prevItems.first?.city) == fakeResponse.first?.city
        expect(self.listViewModel.prevItems.first?.history.last?.value) == fakeResponse.first?.aqi
        
        listViewModel.unsubscribe()
    }
    
    func testDataInformationWhenPrevItemsAvailable() {
        
        let item = CityDataModelData(city: "Mumbai")
        item.history = [AQIModel(value: 100, date: Date())]
        listViewModel.prevItems = [item]
     
        listViewModel.subscribe()
        
        expect(self.listViewModel.prevItems.first?.city) == "Mumbai"
        expect(self.listViewModel.prevItems.first?.history.last?.value) == 100
        
        listViewModel.unsubscribe()
    }
    
    func testErrorResponse() {
        
        listViewModelError.subscribe()
        
        let p = self.listViewModelError.prevItems
        expect(p.count) == 0
        
    }
    
}
