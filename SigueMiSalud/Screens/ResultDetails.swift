//
//  SwiftUIView.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/22/23.
//

import SwiftUI

struct ResultDetails: View {
  let result: HealthResult
  var body: some View {
    ScrollView {
      VStack {
        Text(result.Name)
          .font(.title3)
          .fontWeight(.bold)
        ForEach(result.Results) { item in
          VStack {
            HStack(alignment: .top) {
              VStack(alignment: .leading) {
                Text(item.Name)
                  .font(.body)
                  .fontWeight(.bold)
                HStack(spacing: 2) {
                  Text(item.NormalRange ?? "")
                    .font(.caption)
                  Text(item.Measurement.Units ?? "")
                    .font(.caption)
                }
              }
              Spacer()
              VStack(alignment: .trailing) {
                Text(item.Measurement.PrintableString)
                  .font(.body)
                if item.IsAbnormal {
                  Text(item.AbnormalValue?.rawValue ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .foregroundStyle(Color.white)
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.red))
                }
                Spacer()
              }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            Divider()
          }
        }
        VStack {
          ForEach(result.Results) { item in
            if let description = item.Description {
              Text(item.Name)
                .font(.caption)
                .fontWeight(.bold)
              Text(description)
                .font(.caption2)
                .padding(.bottom, 8)
            } else {
              EmptyView()
            }
          }
        }
        Spacer()
      }
    }
  }
}

#Preview {
  ResultDetails(result:
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
          )
        ])
  )
}
