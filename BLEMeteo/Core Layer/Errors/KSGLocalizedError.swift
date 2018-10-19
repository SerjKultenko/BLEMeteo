//
//  KSGLocalizedError.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 13/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation

struct KSGLocalizedError: LocalizedError {
  
  var code: Int?
  var errorDescription: String? { return _description }
  var failureReason: String? { return _description }
  
  private var _description: String
  
  init(description: String, code: Int? = nil) {
    self._description = description
    self.code = code
  }
  
  static func unknown() -> KSGLocalizedError {
    return KSGLocalizedError(description: "Unknown Error")
  }
}
