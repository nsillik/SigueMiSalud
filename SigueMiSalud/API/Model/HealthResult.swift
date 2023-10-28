//
//  Results.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/22/23.
//

import Foundation

struct HealthResult: Identifiable, Codable {
  struct ResultItem: Identifiable, Codable {
    enum Normality: String, Codable {
      case Unknown, Abnormal, High, Low, Normal
    }

    struct ResultMeasurement: Codable {
      let Value: String
      let NumericValue: Double?
      let Units: String?
      let PrintableString: String
    }

    var id: String { return self.Id.Value }
    let Id: ResultIdentifier
    let AbnormalValue: Normality?
    let IsAbnormal: Bool
    let Measurement: ResultMeasurement
    let Name: String
    let NormalRange: String?
    let Description: String?
  }

  struct DateTime: Codable {
    let UnixTimestamp: TimeInterval
  }

  var id: String { return Id.Value }

  let Id: ResultIdentifier
  let Name: String
  let OrderDate: TimeInterval
  let CollectedDate: TimeInterval?
  let ResultDate: TimeInterval?
  let DateTime: DateTime
  let TypeName: String
  let Results: [ResultItem]
}

struct ResultIdentifier: Codable {
  let Value: String
}


