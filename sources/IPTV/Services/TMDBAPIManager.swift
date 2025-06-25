//
//  TMDBAPIManager.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import Foundation
import IPTVInterfaces
import IPTVModels

class TMDBAPIManager {
  static let shared = TMDBAPIManager()
  static let apiKey: String = AppConfig.tmpdbApiKey

  func fetchImages(forMediaID id: Int, isMovie: Bool) async throws -> TMDBResponse {
    let endpoint = isMovie
      ? "https://api.themoviedb.org/3/movie/\(id)/images"
      : "https://api.themoviedb.org/3/tv/\(id)/images"

    guard var urlComponents = URLComponents(string: endpoint) else {
      throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
    }

    urlComponents.queryItems = [
      URLQueryItem(name: "api_key", value: TMDBAPIManager.apiKey),
      URLQueryItem(name: "language", value: "fr-FR"),
      URLQueryItem(name: "include_image_language", value: "fr,null"),
    ]

    guard let url = urlComponents.url else {
      throw NSError(domain: "Invalid URL Components", code: -1, userInfo: nil)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    let images = try JSONDecoder().decode(TMDBResponse.self, from: data)
    return images
  }
}
