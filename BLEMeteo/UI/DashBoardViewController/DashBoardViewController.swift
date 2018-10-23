//
//  DashBoardViewController.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 19/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import UIKit
import RxSwift

class DashBoardViewController: UIViewController, ISignalsProcessingViewController {
    // MARK: - Vars
    var viewModel: DashBoardViewModel?
    internal let disposeBag = DisposeBag()
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Const
    private let kDashBoardCellReuseIdentifier = "DashBoardCellReuseIdentifier"
    
    
    // MARK: - View Controller Lifecycle
    override func loadView() {
        view = Bundle.main.loadNibNamed(self.classString(), owner: self, options: nil)?[0] as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SensorTableViewCell", bundle: nil), forCellReuseIdentifier: kDashBoardCellReuseIdentifier)
        
        if viewModel != nil {
            bindSignalProcessing(forBaseViewModel: viewModel!)
        }
        reactiveBindings()
    }
    
    private func reactiveBindings() {
        viewModel?.reloadDataSignal
            .observeOn(MainScheduler.instance)
            .subscribe({[weak self] (event) in
                guard let safeSelf = self else {return}
                switch event {
                case let .next(shouldReloadData):
                    if shouldReloadData {
                        safeSelf.tableView.reloadData()
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }

    // MARK: - Actions
    
}

extension DashBoardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sensorsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sensorName(forIndex: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SensorTableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: kDashBoardCellReuseIdentifier) as? SensorTableViewCell
        if let sensor = viewModel?.sensor(withIndex: indexPath.section) {
            cell.sensorData = sensor
            cell.initializeChart()
        }
        return cell
    }
}

extension DashBoardViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
}
