//
//  Auth.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/21/23.
//

import Foundation

struct LoginRequest: Codable {
  let Mode: String
  let MultifactorPinCode: String?
  let MultifactorTimeCode: String?
  let MultifactorMethod: String?
  let Password: String
  let Username: String
  let EnvironmentName: String
  let DefaultHostUrl: String
  let ImproveLoginSecuritySupportLink: String

  init(username: String, password: String) {
    self.Mode = "default"
    self.MultifactorPinCode = nil
    self.MultifactorTimeCode = nil
    self.MultifactorMethod = nil
    self.Username = username
    self.Password = password
    self.EnvironmentName = "Production"
    self.DefaultHostUrl = "https://www.followmyhealth.com"
    self.ImproveLoginSecuritySupportLink = "https://support.followmyhealth.com/2020/03/08/making-your-account-more-secure/"
  }
}

struct LoginResponse: Codable {
//  {
//    "MultifactorMethod": null,
//    "MultifactorTimeCode": "0001-01-01T00:00:00",
//    "ReturnToUrl": "https://www.followmyhealth.com/OpenId/ProviderResponse?provider=UniversalHealthRecord&claimed_id=https%3a%2f%2fsecure.followmyhealth.com%2fuser%2f8e170f37-4ef4-4e7d-91a0-fabf5dd40b09&username=nick%40sillik.org&returnArea=&nonce=20231021032407255326PM&sig=aVBzy8edTGWbNXNnpP2UJ5rzDunIYZwjnXB0yhiGnmNlWExZM3c2NExaczlZSWtrdGtWczRpV2UvK2phdlZrPQ%3d%3d",
//    "StatusCode": 13,
//    "UserId": null,
//    "UserIdHash": null,
//    "MultifactorMaskedContact": null,
//    "MultiFactorAttemptsRemaining": 0,
//    "IsMultiFactorBlocked": false,
//    "MultiFactorPinCodeHash": null,
//    "MultifactorMethodResponse": null,
//    "VerificationKey": null,
//    "Email": null,
//    "Phone": null
//  }

  let ReturnToUrl: String
}
