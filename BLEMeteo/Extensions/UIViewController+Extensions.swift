//
//  UIViewController+Extensions.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 16/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
  func showLoadingHUD() {
    let activityData = ActivityData(size: nil,
                                    message: "Loading...",
                                    messageFont: nil,
                                    type: .lineScale,
                                    color: nil,
                                    padding: nil,
                                    displayTimeThreshold: nil,
                                    minimumDisplayTime: nil,
                                    backgroundColor: nil,
                                    textColor: nil)
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
  }
  
  func hideLoadingHUD() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
  }
  
  func presentAlertWithMessage(_ message: String) {
    let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alertView, animated: true)
  }
  
  func presentMessageBox(_ message: String, withTitle title: String = "Success") {
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alertView, animated: true)
  }

}
