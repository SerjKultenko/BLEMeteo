//
//  IRootRouter.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 24/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import UIKit

struct RootVCContext {
    let appState: StateStorage
    let window: UIWindow
}

protocol IRootRouter {
    var rootVCContext: RootVCContext? { get set}
}
