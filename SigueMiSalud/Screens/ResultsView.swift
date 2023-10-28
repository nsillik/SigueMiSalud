//
//  ResultsView.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/22/23.
//

import SwiftUI

struct ResultsView: View {
  let results: [HealthResult]
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(results) { result in
            ResultRow(result: result)
          }
        }
      }
      .navigationTitle("Results")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ResultRow: View {
  let result: HealthResult
  
  var indicatorColor: Color {
    result.Results.map { $0.IsAbnormal }.contains(where: {$0}) ? Color.red : Color.clear
  }
  
  var body: some View {
    NavigationLink {
      ResultDetails(result: result)
    } label: {
      VStack {
        HStack {
          VStack(alignment: .leading) {
            Text(result.Name)
              .font(.body)
              .fontWeight(.bold)
            if let collectedDate = result.CollectedDate {
              Text(DateFormatters.dateFormatter.string(from: Date(timeIntervalSince1970: collectedDate)))
                .font(.caption)
            } else {
              Text("")
            }
          }
          Spacer()
          Image(systemName: "circle.fill")
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundColor(indicatorColor)
          Image(systemName: "chevron.right")
        }
        .padding(8)
        Divider()
      }
      .background(Color.almostClear)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ResultsView(results: [
    .init(
      Id: .init(Value: "a"),
      Name: "Pants",
      OrderDate: Date.now.timeIntervalSince1970,
      CollectedDate: Date.now.timeIntervalSince1970,
      ResultDate: Date.now.timeIntervalSince1970,
      DateTime: .init(UnixTimestamp: Date.now.timeIntervalSince1970),
      TypeName: "Result",
      Results: [
        .init(
          Id: .init(Value: "a"),
          AbnormalValue: .Abnormal,
          IsAbnormal: true,
          Measurement: .init(
            Value: "4",
            NumericValue: 4,
            Units: "Horses",
            PrintableString: "4 Horses/Sec"
          ),
          Name: "Horses",
          NormalRange: "0-2 Horses",
          Description: nil
        ),
        .init(
          Id: .init(Value: "b"),
          AbnormalValue: .Normal,
          IsAbnormal: false,
          Measurement: .init(
            Value: "69",
            NumericValue: 69,
            Units: "Bleps",
            PrintableString: "69 µBleps"
          ),
          Name: "Bleps",
          NormalRange: "20-100 µBleps",
          Description: nil
        )
      ]),
    .init(
      Id: .init(Value: "b"),
      Name: "Blaps",
      OrderDate: Date.now.timeIntervalSince1970,
      CollectedDate: Date.now.timeIntervalSince1970,
      ResultDate: Date.now.timeIntervalSince1970,
      DateTime: .init(UnixTimestamp: Date.now.timeIntervalSince1970),
      TypeName: "Result",
      Results: [
        .init(
          Id: .init(Value: "a"),
          AbnormalValue: .Normal,
          IsAbnormal: false,
          Measurement: .init(
            Value: "4",
            NumericValue: 4,
            Units: "Horses",
            PrintableString: "4 Horses/Sec"
          ),
          Name: "Horses",
          NormalRange: "0-2 Horses",
          Description: nil
        )
      ])
  ])
}
