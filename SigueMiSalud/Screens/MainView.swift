//
//  MainView.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/21/23.
//

import SwiftUI

struct MainView: View {
  @Environment(\.userToken) var userToken
  @State var response: APIResult<[HealthResult]>?
  @Environment(\.apiClient) var apiClient

  var body: some View {
    switch response {
    case .none:
      Text("Loading your results")
        .task {
          response = await apiClient.fetchAllResults(userToken!)
        }
    case .some(let result):
      switch result {
      case .success(let results):
        ResultsView(results: results)
      case .failure(let error):
        VStack {
          Text("Uh Oh, there was an error")
          Text("\(error.localizedDescription)")
        }
      }
    }
  }
}

#Preview {
  MainView()
}
