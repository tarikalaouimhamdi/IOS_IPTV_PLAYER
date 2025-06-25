//
//  CachedStream.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import RealmSwift
import SwiftUI

public class CachedStream: Object, ObjectKeyIdentifiable {
  @Persisted public var identifier: ObjectId
  @Persisted(primaryKey: true) public var id: Int
  @Persisted public var name: String
  @Persisted public var streamType: String
  @Persisted public var streamIcon: String
  @Persisted public var added: Date
  @Persisted public var rating: String?
  @Persisted public var desc: String?
  @Persisted public var tmdb: String?
  @Persisted public var tmdbImage: String?
  @Persisted public var section: String
  @Persisted public var categoryId: String
  @Persisted public var year: Int?
  @Persisted public var isFavorite: Bool
  @Persisted public var containerExtension: String

  public var kindMedia: KindMedia {
    KindMedia(rawValue: section) ?? .vod
  }

  public var searchName: String {
    name.lowercased()
  }

  public convenience init(id: Int, name: String, streamType: String, streamIcon: String, section: String, added: Date, categoryId: String, rating: String? = nil, desc: String? = nil, tmdb: String? = nil, tmdbImage: String? = nil, year: Int?, containerExtension: String? = "mkv") {
    self.init()
    self.id = id
    self.name = name
    self.streamType = streamType
    self.streamIcon = streamIcon
    self.section = section
    self.added = added
    self.rating = rating
    self.desc = desc
    self.tmdb = tmdb
    self.tmdbImage = tmdbImage
    self.categoryId = categoryId
    self.year = year
    self.isFavorite = false
    self.containerExtension = containerExtension ?? "mkv"
  }

  public func getImage() -> String? {
    return streamIcon
  }
}
