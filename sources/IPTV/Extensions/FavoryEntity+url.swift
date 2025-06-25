//
//  FavoryEntity+url.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 24/06/2025.
//
import IPTVModels

public extension FavoriEntity {
  func streamURL() -> String {
    switch kindMedia {
    case .live:
      return "\(APIManager.shared.liveURL)/\(id)"
    case .vod:
      return "\(APIManager.shared.vodURL)/\(id).mkv"
    case .series:
      return "\(APIManager.shared.serieURL)/\(id).mkv"
    default:
      return "get_live_categories"
    }
  }
}
