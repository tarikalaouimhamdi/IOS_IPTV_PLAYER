//
//  Episode+url.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 24/06/2025.
//
import IPTVModels

public extension Episode {
  func streamURL() -> String {
    return "\(APIManager.shared.serieURL)/\(id).\(containerExtension ?? "mkv")"
  }
}
