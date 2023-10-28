//
//  ContentView.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/21/23.
//

import SwiftUI
import SwiftJWT

struct ContentView: View {
  enum ViewState {
    case loggedOut(APIError?), loading, loggedIn(UserToken)
  }

  @State var state: ViewState = .loggedOut(nil)
  @State var username: String = StaticLogin.username
  @State var password: String = StaticLogin.password
  @Environment(\.apiClient) var apiClient

  var body: some View {
    switch state {
    case .loggedOut(_):
      loginView
    case .loading:
      VStack {
        Spacer()
        Text("Logging In!")
        ProgressView()
        Spacer()
      }
    case .loggedIn(let token):
      MainView()
        .environment(\.userToken, token)
    }
  }

  var loginView: some View {
    VStack(alignment: .center, spacing: 16) {
      Text("WELCOME TO YOUR HEALTH")
        .font(.largeTitle)
      TextField("email", text: $username)
        .textFieldStyle(.roundedBorder)
      SecureField("password", text: $password)
        .textFieldStyle(.roundedBorder)
      Button("Login") {
        Task {
          self.state = .loading
          let result = await apiClient.login(username, password)
          switch result {
          case .success(let jwt):
            self.state = .loggedIn(jwt)
          case .failure(let error):
            state = .loggedOut(error)
          }
        }
      }
      .buttonStyle(.borderedProminent)
      .disabled(username.isEmpty || password.isEmpty)

      switch state {
      case .loggedOut(let error):
        Spacer()
        if let error = error {
          Group {
            Text("Error Logging In:")
            Text("\(error.localizedDescription)")
          }
          .foregroundColor(.red.opacity(0.8))
        }
      case .loading:
        EmptyView()
      case .loggedIn(_):
        EmptyView()
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
