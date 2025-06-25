//
//  CachedStream+url.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 25/06/2025.
//
import Foundation
import IPTVModels

public extension CachedStream {
  func getTmdbImage() async -> String? {
    guard streamType == "movie" else { return streamIcon }

    guard let tmdb,
          let tmdbId = NumberFormatter().number(from: tmdb)?.intValue,
          let medias = try? await TMDBAPIManager.shared.fetchImages(forMediaID: tmdbId, isMovie: streamType == "movie") else { return streamIcon }

    guard let firstImage = medias.posters.first?.filePath else { return streamIcon }
    return "https://image.tmdb.org/t/p/original\(firstImage)"
  }

  func streamURL() -> String {
    switch kindMedia {
    case .live:
      return "\(APIManager.shared.liveURL)/\(id)"
    case .vod:
      return "\(APIManager.shared.vodURL)/\(id).\(containerExtension)"
    case .series:
      return "\(APIManager.shared.serieURL)/\(id).\(containerExtension)"
    default:
      return "get_live_categories"
    }
  }
}
