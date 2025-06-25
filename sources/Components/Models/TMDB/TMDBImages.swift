//
//  TMDBImages.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//
import Foundation

public struct TMDBImage: Decodable, Identifiable {
  public let id = UUID() // Pour conformer à Identifiable
  public let filePath: String
  public let voteAverage: Double
  public let voteCount: Int

  enum CodingKeys: String, CodingKey {
    case filePath = "file_path"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
}

public struct TMDBResponse: Decodable {
  public let backdrops: [TMDBImage]
  public let posters: [TMDBImage]
  public let logos: [TMDBImage]
}
