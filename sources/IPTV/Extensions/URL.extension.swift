//
//  URL.extension.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 12/11/2024.
//
import Foundation

extension URLCache {
  static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
