//
//  FavoriEntity.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 13/11/2024.
//
import RealmSwift
import SwiftUI

public class FavoriEntity: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) public var _identifier: ObjectId
  @Persisted public var id: Int
  @Persisted public var kind: String
  @Persisted public var name: String
  @Persisted public var streamIcon: String?
  @Persisted public var added: Date
  @Persisted public var tmdb: String?

  public convenience init(id: Int, kind: String, name: String, streamIcon: String?, added _: Date, tmdb: String? = nil) {
    self.init()
    self.id = id
    self.kind = kind
    self.name = name
    self.streamIcon = streamIcon
    self.added = Date()
    self.tmdb = tmdb
  }

  public var kindMedia: KindMedia {
    KindMedia(rawValue: kind) ?? .vod
  }

  public func getImage() -> String? {
    return streamIcon
  }
}
