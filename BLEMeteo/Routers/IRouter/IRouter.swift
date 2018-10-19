///
//  IRouter.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 23/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit

protocol IRouter {
    // The view controller to show the new one. Should be "weak"
    var presentingViewController: UIViewController? { get set }
    
    /// Presents the new View Controller
    ///
    /// - Parameters:
    ///   - presentingVC: The VC to show the new one on. Might be nil in case if we present the VC as the Root View Controller
    ///   - context: Any parameter
    ///   - animated: animated presenting or not
    ///   - completion: The closure to be called when presentation finishes with a result (was presented or not)
    func present(on presentingVC: UIViewController?, context: Any?, animated: Bool, completion: ((Bool) -> Void)?)
    
    /// Presents the new View Controller as a result of certain operation on previously defined Presenting VC
    ///
    /// - Parameters:
    ///   - context: Any parameter
    ///   - animated: animated presenting or not
    ///   - completion: The closure to be called when presentation finishes with a result (was presented or not)
    func route(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?)
    
    
    /// Dismisses the current VC and returns to the presenting VC
    ///
    /// - Parameters:
    ///   - context: Any parameter
    ///   - animated: animated presenting or not
    ///   - completion: The closure to be called when dismissing finishes with a result (successfully dismissed or not)
    func dismiss(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?)
}

extension IRouter {
    
    func present(on presentingVC: UIViewController) {
        self.present(on: presentingVC, context: nil, animated: true, completion: nil)
    }
    
    func route(with context: Any?) {
        self.route(with: context, animated: true, completion: nil)
    }
    
    func route(with context: Any?, completion: ((Bool) -> Void)?) {
        self.route(with: context, animated: true, completion: completion)
    }
    
}

extension IRouter where Self: AnyObject {
  func classString() -> String {
    return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
  }
  
  static func classString() -> String {
    return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
  }
}

