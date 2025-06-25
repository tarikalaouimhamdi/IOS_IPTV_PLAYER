//
//  Stream.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//
import SwiftUI

public struct Stream: Identifiable, Decodable {
  public let id: Int
  public let name: String
  public let streamType: String
  public let streamIcon: String
  public let rating: String?
  public let description: String?
  public let tmdb: FlexibleString?
  public let added: Date
  public let categoryId: String
  public let year: Int?
  public let containerExtension: String

  public var kindMedia: KindMedia {
    switch streamType {
    case "movie":
      return .vod
    case "series":
      return .series
    default:
      return .live
    }
  }

  enum CodingKeys: String, CodingKey {
    case id = "stream_id"
    case name
    case streamType = "stream_type"
    case streamIcon = "stream_icon"
    case rating
    case tmdb
    case description = "plot" // Par exemple pour les séries
    case added
    case categoryId = "category_id"
    case containerExtension = "container_extension"
  }

  public init(id: Int, name: String, streamType: String, streamIcon: String, categoryId: String, rating: String? = nil, description: String? = nil, tmdb: FlexibleString? = nil, added: Date, year: Int? = nil, containerExtension: String? = "mkv") {
    self.id = id
    self.name = name
    self.streamType = streamType
    self.streamIcon = streamIcon
    self.rating = rating
    self.description = description
    self.tmdb = tmdb
    self.added = added
    self.categoryId = categoryId
    self.year = year
    self.containerExtension = containerExtension ?? "mkv"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.streamType = try container.decode(String.self, forKey: .streamType)
    self.streamIcon = try container.decode(String.self, forKey: .streamIcon)
    self.categoryId = try container.decode(String.self, forKey: .categoryId)
    self.rating = try? container.decode(String.self, forKey: .rating)
    self.description = try? container.decode(String.self, forKey: .description)
    self.tmdb = try? container.decode(FlexibleString.self, forKey: .tmdb)
    // Décodage manuel pour le champ `added`
    let addedValue = try container.decode(String.self, forKey: .added)
    if let timestamp = Double(addedValue) {
      self.added = Date(timeIntervalSince1970: timestamp)
    } else {
      throw DecodingError.typeMismatch(
        Date.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Invalid format for `added`. Expected a timestamp in seconds."
        )
      )
    }
    self.containerExtension = (try? container.decode(String.self, forKey: .containerExtension)) ?? ""
    self.year = Int(Stream.extractYear(from: name) ?? "0")
  }

  // Méthode statique pour extraire l'année
  public static func extractYear(from name: String) -> String? {
    let pattern = "\\((\\d{4})\\)" // Recherche de l'année entre parenthèses
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: name.utf16.count)

    if let match = regex?.firstMatch(in: name, options: [], range: range),
       let yearRange = Range(match.range(at: 1), in: name) {
      return String(name[yearRange])
    }
    return nil
  }
}

// Type pour gérer les cas String ou Number
public enum FlexibleString: Decodable {
  case string(String)
  case number(Int)

  public var value: String {
    switch self {
    case let .string(stringValue):
      return stringValue
    case let .number(intValue):
      return String(intValue)
    }
  }

  public init(from value: String?) {
    self = .string(value ?? "")
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let stringValue = try? container.decode(String.self) {
      self = .string(stringValue)
    } else if let intValue = try? container.decode(Int.self) {
      self = .number(intValue)
    } else {
      throw DecodingError.typeMismatch(
        FlexibleString.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Value is neither String nor Number"
        )
      )
    }
  }
}
