//
//  CachedSeries+url.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 24/06/2025.
//
import Foundation
import IPTVModels

public extension CachedSeries {
  func streamURL() -> String {
    return "\(APIManager.shared.serieURL)/\(id).mkv"
  }

  func getTmdbImage() async -> String? {
    guard tmdb.count > 0 else { return nil }
    guard let tmdbId = NumberFormatter().number(from: tmdb)?.intValue,
          let medias = try? await TMDBAPIManager.shared.fetchImages(forMediaID: tmdbId, isMovie: false) else { return cover }

    guard let firstImage = medias.posters.first?.filePath else { return cover }
    return "https://image.tmdb.org/t/p/original\(firstImage)"
  }
}
