//
//  AQIGraphVC.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 24/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class AQIGraphVC: UIViewController {
    
    var cityModel: CityDataModelData = CityDataModelData(city: "")
    
    private var viewModel: DetailViewModel?
    
    private var bag = DisposeBag()
    
    private let chartView = LineChartView()
    
    var dataEntries = [ChartDataEntry]()

    // Determine how many dataEntries show up in the chartView
    var xValue: Double = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DetailViewModel(dataProvider: DataProvider())
        
        self.title = cityModel.city
        
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        setupInitialDataEntries()
        
        setupChartData()
        
        bindData()
    }
    
    func bindData() {
     
        viewModel?.item.bind { model in
        
            if let v = model.history.last?.value {
                let roundingValue: Double = Double(round(v * 100) / 100.0)
                
                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }
                
        }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe
        viewModel?.subscribe(forCity: cityModel.city)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
}

// Graph UI
extension AQIGraphVC {
    
    func setupInitialDataEntries() {
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntries.append(dataEntry)
        }
    }
    
    func setupChartData() {
        // 1
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "AQI for " + self.cityModel.city)
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawIconsEnabled = true
        chartDataSet.setColor(.systemBlue)
        chartDataSet.mode = .linear
        chartDataSet.setCircleColor(.systemBlue)
        if let font = UIFont(name: "Helvetica Neue", size: 10) {
            chartDataSet.valueFont = font
        }
            
        // 2
        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.labelPosition = .bottom
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        // 1
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        
        // 2
        dataEntries.append(newDataEntry)
        chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)
            
        // 3
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(newDataEntry.x)
    }
    
}
