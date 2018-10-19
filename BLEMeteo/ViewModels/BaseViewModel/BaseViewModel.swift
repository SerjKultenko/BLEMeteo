//
//  BaseViewModel.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 16/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
  // Router
  var router: IRouter
  
  // Subjects to signal to View Controller
  var showHUDSignal = BehaviorSubject<Bool>(value: false)
  var showErrorAlertSignal = PublishSubject<String>()
  var showMessageBoxSignal = PublishSubject<String>()
  
  // RX Swift Dispose Bag
  let disposeBag = DisposeBag()
  
  // MARK: - Initalization
  init(with router: IRouter) {
    self.router = router
  }
  
}
