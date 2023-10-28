//
//  Results.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/22/23.
//

import Foundation

struct ResultsResponse: Codable {
  let Results: [HealthResult]
  let Next: Pagination?
  let HasMore: Bool

  struct Pagination: Codable {
    let _pageSize: Int
    let _continuationToken: String
  }
}
