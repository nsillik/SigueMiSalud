//
//  DateUtils.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/28/23.
//

import Foundation

enum DateFormatters {
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }
}
