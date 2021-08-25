//
//  ListVC.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 23/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class ListVC: UIViewController {
    
    private var viewModel: ListViewModel?
    
    private var bag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityIdentifier = "table--cityTableView"
        
        viewModel = ListViewModel(dataProvider: DataProvider())
        
        bindTableData()
    }

    func bindTableData() {
        
        // bind items to table
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: "CityDataCell", cellType: CityDataCell.self)) {row, model, cell in
            
            cell.cityData = model
            
        }.disposed(by: bag)
        
        // bind a model selected handler
        tableView.rx.modelSelected(CityDataModelData.self).bind { item in
            
            let cityDetail: AQIGraphVC = self.storyboard?.instantiateViewController(identifier: "AQIGraphVC") as! AQIGraphVC
            cityDetail.cityModel = item
            self.navigationController?.pushViewController(cityDetail, animated: true)            
            
        }.disposed(by: bag)
        
        
        // set delegate
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe to AQIs Socket Connection
        viewModel?.subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
    deinit {
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}



