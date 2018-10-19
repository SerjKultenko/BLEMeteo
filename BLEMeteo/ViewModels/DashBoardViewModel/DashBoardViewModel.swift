//
//  DashBoardViewModel.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 19/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class DashBoardViewModel: BaseViewModel {
    
    private var appState: StateStorage
    
    // MARK: - Vars
    var reloadDataSignal = BehaviorSubject<Bool>(value: false)
    
    var sensorsCount: Int {
        return 3
    }
    
/*    var presetUpdated: PublishSubject<GeneratorPreset> {
        return appState.currPresetUpdated
    }
    
    private var languageUnits: [LanguageUnit] = [] {
        didSet {
            reloadDataSignal.onNext(true)
        }
    }
    
    var linesCount: Int {
        return languageUnits.count
    }
    
    func getLanguageUnit(atIndex index: Int) -> LanguageUnit? {
        guard index >= 0, languageUnits.count > index else { return nil }
        return languageUnits[index]
    }
    
    
    // MARK: - Utilities
    
    
    // MARK: - Actions
    func reloadData() {
        showHUDSignal.onNext(true)
        
        DispatchQueue.global().async { [weak self] in
            guard let safeSelf = self else { return }
            
            var units = [LanguageUnit]()
            for generator in safeSelf.appState.currentPreset.generators {
                if generator.active {
                    units.append(contentsOf: generator.generate())
                }
            }
            safeSelf.languageUnits = units
            safeSelf.showHUDSignal.onNext(false)
        }
    }
    
    func changePreset() {
        router.route(with: MainScreenRouter.RouteType.changePreset, animated: true, completion: nil)
    }
    */
    // MARK: - Initialization
    init(withRouter router: IRouter, appState: StateStorage) {
        self.appState = appState
        super.init(with: router)
    }
}
