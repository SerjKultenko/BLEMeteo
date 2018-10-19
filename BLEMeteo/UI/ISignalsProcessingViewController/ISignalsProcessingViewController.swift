//
//  ISignalsProcessingViewController.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 17/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit
import RxSwift

protocol ISignalsProcessingViewController {
  var disposeBag: DisposeBag { get }

  func bindSignalProcessing(forBaseViewModel viewModel: BaseViewModel)
}

extension ISignalsProcessingViewController where Self: UIViewController {
  
  func bindSignalProcessing(forBaseViewModel viewModel: BaseViewModel) {
    viewModel.showHUDSignal
      .observeOn(MainScheduler.instance)
      .subscribe({[weak self] (event) in
      guard let strongSelf = self else {return}
      switch event {
      case let .next(value):
        if value {
          strongSelf.showLoadingHUD()
        } else {
          strongSelf.hideLoadingHUD()
        }
      default:
        strongSelf.hideLoadingHUD()
        break
      }
    }).disposed(by: disposeBag)
    
    viewModel.showErrorAlertSignal
      .observeOn(MainScheduler.instance)
      .subscribe({[weak self] (event) in
      guard let strongSelf = self else {return}
      switch event {
      case let .next(value):
        strongSelf.presentAlertWithMessage(value)
      default:
        break
      }
    }).disposed(by: disposeBag)
    
    viewModel.showMessageBoxSignal
      .observeOn(MainScheduler.instance)
      .subscribe({[weak self] (event) in
      guard let strongSelf = self else {return}
      switch event {
      case let .next(value):
        strongSelf.presentMessageBox(value)
      default:
        break
      }
    }).disposed(by: disposeBag)
  }
}
