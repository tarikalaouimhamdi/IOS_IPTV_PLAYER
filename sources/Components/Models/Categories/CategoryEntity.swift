//
//  CategoryEntity.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import RealmSwift

public class CategoryEntity: Object, ObjectKeyIdentifiable {
  @Persisted public var _identifier: ObjectId
  @Persisted(primaryKey: true) public var id: String
  @Persisted public var name: String
  @Persisted public var parentId: Int
  @Persisted public var section: String // "Live", "VOD", "Series"

  public convenience init(id: String, name: String, parentId: Int, section: String) {
    self.init()
    self.id = id
    self.name = name
    self.parentId = parentId
    self.section = section
  }
}
