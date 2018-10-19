//
//  DashBoardRouter.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 19/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import UIKit

class DashBoardRouter: IRouter, IRootRouter {
    
    enum RouteType {
    }
    
    var rootVCContext: RootVCContext?
    
    weak var presentingViewController: UIViewController?
    
    func present(on presentingVC: UIViewController?, context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
        guard let rootVCContext = context as? RootVCContext  else {
            assertionFailure(String(format:"Initial context in %@ is not of RootVCContext type" , self.classString()) )
            return
        }
        self.rootVCContext = rootVCContext
        
        let vc = DashBoardViewController()
        let viewModel = DashBoardViewModel(withRouter: self, appState: rootVCContext.appState)
        vc.viewModel = viewModel
        
        UIView.transition(with: rootVCContext.window, duration: 0.35, options: .transitionCrossDissolve, animations: {
            let navigation = UINavigationController(rootViewController: vc)
            self.presentingViewController = navigation
            rootVCContext.window.rootViewController = navigation
        }, completion: nil)
    }
    
    func route(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
        guard let routeType = context as? RouteType else {
            assertionFailure(String(format:"Context in %@ is not RouteType" , self.classString()) )
            return
        }
        //    guard let presentingViewController = presentingViewController else {
        //      assertionFailure("presentingViewController was not set")
        //      return
        //    }
        
//        switch routeType {
//        case .gotoGeneratorProperties:
//            break
//        case .changePreset:
//            let router = PresetsRouter()
//            router.present(on: presentingViewController, context: rootVCContext?.appState, animated: true, completion: nil)
//        }
    }
    
    func dismiss(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
        // Empty
    }
    
}
