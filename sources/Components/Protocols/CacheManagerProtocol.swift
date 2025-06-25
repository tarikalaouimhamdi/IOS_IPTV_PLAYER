//
//  CacheManager.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 23/12/2024.
//

import Foundation
import IPTVModels
import RealmSwift
import SwiftUI

/// sourcery: AutoMockableIPTV
public protocol CacheManagerProtocol {
  func cacheCategories(_ categories: [IPTVModels.Category], for section: String) async
  func cacheStreams(_ streams: [IPTVModels.Stream], for section: String)
  func cacheSeries(_ series: [Series], for section: String)

  func fetchCachedCategories(for section: String) -> [CategoryEntity]
  func fetchCachedStream(for section: String, categoryId: String) -> [IPTVModels.Stream]
  func fetchFilteredCategories(for section: String) -> [CategoryEntity]
}
