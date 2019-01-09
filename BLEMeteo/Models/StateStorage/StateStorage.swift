//
//  StateStorage.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 16/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class StateStorage: Codable {
  
  // MARK: - Persistens Support
  static private let kAppStateStorageKey = "kAppStateStorageKey"

  static func loadFromUserDefaults() -> StateStorage? {
    guard let jsonData = UserDefaults.standard.object(forKey: kAppStateStorageKey) as? Data else {
      return nil
    }
    return try? JSONDecoder().decode(StateStorage.self, from: jsonData)
  }

  func saveToUserDefaults() {
    let encodedData = try? JSONEncoder().encode(self)
    UserDefaults.standard.set(encodedData, forKey: StateStorage.kAppStateStorageKey)
  }

  // MARK: - Initialization
}
