//
//  Object+Extensions.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 13/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation

extension NSObject {
  
  open func classString() -> String {
    return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
  }
  
  open class func classString() -> String {
    return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
  }
}
