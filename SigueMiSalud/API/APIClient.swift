//
//  APIClient.swift
//  SigueMiSalud
//
//  Created by Nick Sillik on 10/21/23.
//

import Foundation
import SwiftJWT
import SwiftUI

private struct APIClientKey: EnvironmentKey {
  static let defaultValue: APIProvider = APIClient()
}

// 2. Extend the environment with our property
extension EnvironmentValues {
  var apiClient: APIProvider {
    get { self[APIClientKey.self] }
    set { self[APIClientKey.self] = newValue }
  }
}

enum APIError: Error {
  case unknown(String)
  case underlyingError(Error)
}

typealias APIResult<Response> = Result<Response, APIError>
typealias UserToken = String

protocol APIProvider {
  func login(_ username: String, _ password: String) async -> (APIResult<UserToken>)
  func getResults(_ userToken: UserToken, _ pagination: ResultsResponse.Pagination?) async -> APIResult<ResultsResponse>
  func fetchAllResults(_ userToken: UserToken) async -> APIResult<[HealthResult]>
}

struct APIClient: APIProvider {
  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  let urlSession = URLSession.shared
  
  func login(_ username: String, _ password: String) async -> (APIResult<UserToken>) {
    guard let url = URL(string: "https://secure.followmyhealth.com/api/Login") else {
      return .failure(.unknown("Unable to construct url"))
    }
    do {
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.httpBody = try encoder.encode(LoginRequest(username: username, password: password))
      request.setValue("https://www.followmyhealth.com/", forHTTPHeaderField: "Referer")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      let (loginData, _) = try await urlSession.data(for: request)
      let res = try decoder.decode(LoginResponse.self, from: loginData)
      print(res.ReturnToUrl)
      guard let returnUrl = URL(string: res.ReturnToUrl) else {
        return .failure(.unknown("Unable to construct return url"))
      }
      let (_, returnResponse) = try await urlSession.data(from: returnUrl)
      guard let httpResponse = returnResponse as? HTTPURLResponse else {
        return .failure(.unknown("Unable to construct http response"))
      }
      print(httpResponse.allHeaderFields)
      guard let auth = httpResponse.allHeaderFields["Authorization"] as? String else {
        return .failure(.unknown("Unable to get authorization header"))
      }
      let split = auth.split(separator: " ")
      let token = String(split[1])
      let _ = try JWT<Claims>(jwtString: token, verifier: .none) // Just verify this is a valid JWT
      return .success(token)
    } catch {
      return .failure(.underlyingError(error))
    }
  }

  func getResults(_ userToken: UserToken, _ pagination: ResultsResponse.Pagination?) async -> APIResult<ResultsResponse> {
    guard let url = URL(string: "https://www.followmyhealth.com/api/patientaccess/PagedResults"),
          var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return .failure(.unknown("Unable to construct URL"))
    }

    let params: URLQueryItem
    switch pagination {
    case .none:
      params = .init(name: "pageSize", value: "50")
    case .some(let pagination):
      params = .init(name: "continuationToken", value: pagination._continuationToken)
    }

    urlComponents.queryItems = [params]
    guard let constructedURL = urlComponents.url else {
      return .failure(.unknown("Unable to construct URL"))
    }

    var urlRequest = URLRequest(url: constructedURL)
    urlRequest.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")

    do {
      let (responseData, _) = try await urlSession.data(for: urlRequest)
      let decodedResponse = try decoder.decode(ResultsResponse.self, from: responseData)
      return .success(decodedResponse)
    } catch {
      print(error)
      return .failure(.underlyingError(error))
    }
  }

  func fetchAllResults(_ userToken: UserToken) async -> APIResult<[HealthResult]> {
    var results: [HealthResult] = []
    var hasNext = true
    var pagination: ResultsResponse.Pagination? = nil
    while hasNext {
      let result = await getResults(userToken, pagination)
      switch result {
      case .success(let resultsResponse):
        results.append(contentsOf: resultsResponse.Results)
        hasNext = resultsResponse.HasMore
        pagination = resultsResponse.Next
      case .failure(let error):
        return .failure(error)
      }
    }
    // Sometimes we get duplicates, so we should uniquify them here
    var seenIds = Set<String>()

    return .success(results.filter({ result in
      if seenIds.contains(result.id) {
        return false
      }

      seenIds.insert(result.id)
      return true
    }))
  }
}

