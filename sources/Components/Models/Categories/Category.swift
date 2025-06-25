//
//  Category.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//
import RealmSwift

public struct Category: Decodable, Identifiable {
  public let id: String
  public let name: String
  public let parentId: Int

  enum CodingKeys: String, CodingKey {
    case id = "category_id"
    case name = "category_name"
    case parentId = "parent_id"
  }
}
