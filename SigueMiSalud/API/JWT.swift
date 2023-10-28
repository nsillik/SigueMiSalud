//
//  JWT.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/21/23.
//

import Foundation
import SwiftJWT

struct Claims: SwiftJWT.Claims {
  let unique_name: String
  let FMHAuthenticationTokenType: String
  let FMHLastLogin: String
  let FMHRole: String
  let auth_time: String
  let nonce: String
  let nbf: Int
  let iat: Int
  let iss: String
  let aud: String
}
