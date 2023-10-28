//
//  User.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/21/23.
//

import SwiftUI
import SwiftJWT

// 1. Create the key with a default value
private struct UserTokenKey: EnvironmentKey {
  static let defaultValue: UserToken? = nil
}

// 2. Extend the environment with our property
extension EnvironmentValues {
  var userToken: UserToken? {
    get { self[UserTokenKey.self] }
    set { self[UserTokenKey.self] = newValue }
  }
}
