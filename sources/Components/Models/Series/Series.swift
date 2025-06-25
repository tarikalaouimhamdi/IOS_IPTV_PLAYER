//
//  Series.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import Foundation

public struct Series: Identifiable, Decodable {
  public let id: Int
  public let name: String
  public let seriesID: Int
  public let cover: String?
  public let plot: String?
  public let cast: String?
  public let director: String?
  public let genre: String?
  public let releaseDate: String?
  public let lastModified: Date
  public let rating: Double?
  public let rating5Based: Double?
  public let backdropPaths: [String]
  public let youtubeTrailer: String?
  public let tmdb: String?
  public let episodeRunTime: Int?
  public let categoryID: String
  public let categoryIDs: [Int]

  enum CodingKeys: String, CodingKey {
    case id = "num"
    case name
    case seriesID = "series_id"
    case cover
    case plot
    case cast
    case director
    case genre
    case releaseDate
    case lastModified = "last_modified"
    case rating
    case rating5Based = "rating_5based"
    case backdropPaths = "backdrop_path"
    case youtubeTrailer = "youtube_trailer"
    case tmdb
    case episodeRunTime = "episode_run_time"
    case categoryID = "category_id"
    case categoryIDs = "category_ids"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .seriesID)
    self.name = try container.decode(String.self, forKey: .name)
    self.seriesID = try container.decode(Int.self, forKey: .id)
    self.cover = try? container.decode(String.self, forKey: .cover)
    self.plot = try? container.decode(String.self, forKey: .plot)
    self.cast = try? container.decode(String.self, forKey: .cast)
    self.director = try? container.decode(String.self, forKey: .director)
    self.genre = try? container.decode(String.self, forKey: .genre)
    self.releaseDate = try? container.decode(String.self, forKey: .releaseDate)

    let lastModifiedTimestamp = try container.decode(String.self, forKey: .lastModified)
    if let timestamp = Double(lastModifiedTimestamp) {
      self.lastModified = Date(timeIntervalSince1970: timestamp)
    } else {
      throw DecodingError.dataCorruptedError(
        forKey: .lastModified,
        in: container,
        debugDescription: "Invalid timestamp for lastModified"
      )
    }

    self.rating = try? container.decode(Double.self, forKey: .rating)
    self.rating5Based = try? container.decode(Double.self, forKey: .rating5Based)
    self.backdropPaths = [] // try container.decodeIfPresent([String].self, forKey: .backdropPaths) ?? []
    self.youtubeTrailer = try? container.decode(String.self, forKey: .youtubeTrailer)
    self.tmdb = try? container.decode(String.self, forKey: .tmdb)
    self.episodeRunTime = 0 // try? container.decode(Int.self, forKey: .episodeRunTime)
    self.categoryID = try container.decode(String.self, forKey: .categoryID)
    self.categoryIDs = [] // try container.decodeIfPresent([Int].self, forKey: .categoryIDs) ?? []
  }

  public init(id: Int, name: String, seriesID: Int, cover: String? = nil, plot: String? = nil, cast: String? = nil, director: String? = nil, genre: String? = nil, releaseDate: String? = nil, lastModified: Date, rating: Double? = nil, rating5Based: Double? = nil, backdropPaths: [String], youtubeTrailer: String? = nil, tmdb: String, episodeRunTime: Int, categoryID: String, categoryIDs: [Int]) {
    self.id = id
    self.name = name
    self.seriesID = seriesID
    self.cover = cover
    self.plot = plot
    self.cast = cast
    self.director = director
    self.genre = genre
    self.releaseDate = releaseDate
    self.lastModified = lastModified
    self.rating = rating
    self.rating5Based = rating5Based
    self.backdropPaths = backdropPaths
    self.youtubeTrailer = youtubeTrailer
    self.tmdb = tmdb
    self.episodeRunTime = episodeRunTime
    self.categoryID = categoryID
    self.categoryIDs = categoryIDs
  }

  // Transformable properties for CoreData compatibility
  var backdropPathsData: Data? {
    try? JSONEncoder().encode(backdropPaths)
  }

  var categoryIDsData: Data? {
    try? JSONEncoder().encode(categoryIDs)
  }

  // Transform data back to arrays
  static func decodeBackdropPaths(from data: Data?) -> [String] {
    guard let data else { return [] }
    return (try? JSONDecoder().decode([String].self, from: data)) ?? []
  }

  static func decodeCategoryIDs(from data: Data?) -> [Int] {
    guard let data else { return [] }
    return (try? JSONDecoder().decode([Int].self, from: data)) ?? []
  }
}

// Info sur la série
public struct SeriesInfo: Decodable {
  public let name: String
  public let cover: String
  public let plot: String?
  public let cast: String?
  public let director: String?
  public let genre: String?
  public let releaseDate: String?
  public let lastModified: Date?
  public let rating: FlexibleString?
  public let rating5Based: FlexibleString?
  public let tmdb: String
  public let backdropPaths: [String]
  public let youtubeTrailer: String?

  enum CodingKeys: String, CodingKey {
    case name
    case cover
    case plot
    case cast
    case director
    case genre
    case releaseDate
    case lastModified = "last_modified"
    case rating
    case rating5Based = "rating_5based"
    case tmdb
    case backdropPaths = "backdrop_path"
    case youtubeTrailer = "youtube_trailer"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.cover = try container.decode(String.self, forKey: .cover)
    self.plot = try container.decodeIfPresent(String.self, forKey: .plot)
    self.cast = try container.decodeIfPresent(String.self, forKey: .cast)
    self.director = try container.decodeIfPresent(String.self, forKey: .director)
    self.genre = try container.decodeIfPresent(String.self, forKey: .genre)
    self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)

    if let lastModifiedString = try? container.decode(String.self, forKey: .lastModified),
       let timestamp = Double(lastModifiedString) {
      self.lastModified = Date(timeIntervalSince1970: timestamp)
    } else if let lastModifiedDouble = try? container.decode(Double.self, forKey: .lastModified) {
      self.lastModified = Date(timeIntervalSince1970: lastModifiedDouble)
    } else {
      self.lastModified = nil
    }
    self.rating = try? container.decodeIfPresent(FlexibleString.self, forKey: .rating)
    self.rating5Based = try? container.decodeIfPresent(FlexibleString.self, forKey: .rating5Based)
    self.tmdb = try container.decode(String.self, forKey: .tmdb)
    self.backdropPaths = try container.decodeIfPresent([String].self, forKey: .backdropPaths) ?? []
    self.youtubeTrailer = try container.decodeIfPresent(String.self, forKey: .youtubeTrailer)
  }

  public init(name: String, cover: String, plot: String? = nil, cast: String? = nil, director: String? = nil, genre: String? = nil, releaseDate: String? = nil, lastModified: Date? = nil, rating: FlexibleString? = nil, rating5Based: FlexibleString? = nil, tmdb: String, backdropPaths: [String], youtubeTrailer: String? = nil) {
    self.name = name
    self.cover = cover
    self.plot = plot
    self.cast = cast
    self.director = director
    self.genre = genre
    self.releaseDate = releaseDate
    self.lastModified = lastModified
    self.rating = rating
    self.rating5Based = rating5Based
    self.tmdb = tmdb
    self.backdropPaths = backdropPaths
    self.youtubeTrailer = youtubeTrailer
  }
}

// Informations sur un épisode
public struct EpisodeInfo: Decodable {
  public let movieImage: String?

  enum CodingKeys: String, CodingKey {
    case movieImage = "movie_image"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.movieImage = try container.decodeIfPresent(String.self, forKey: .movieImage)
  }
}

public struct Episode: Decodable {
  public let id: String
  public let episodeNum: Int
  public let title: String
  public let containerExtension: String?
  public let added: Date?
  public let season: Int
  public let info: EpisodeInfo?

  enum CodingKeys: String, CodingKey {
    case id
    case episodeNum = "episode_num"
    case title
    case containerExtension = "container_extension"
    case added
    case season
    case info
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.episodeNum = try container.decode(Int.self, forKey: .episodeNum)
    self.title = try container.decode(String.self, forKey: .title)
    self.containerExtension = try container.decodeIfPresent(String.self, forKey: .containerExtension)
    if let addedTimestamp = try container.decodeIfPresent(String.self, forKey: .added) {
      self.added = Date(timeIntervalSince1970: TimeInterval(addedTimestamp) ?? 0)
    } else {
      self.added = nil
    }
    self.season = try container.decode(Int.self, forKey: .season)
    self.info = try? container.decodeIfPresent(EpisodeInfo.self, forKey: .info)
  }
}

// Informations sur une saison
public struct Season: Decodable {
  public let name: String
  public let episodeCount: FlexibleString?
  public let overview: String?
  public let airDate: String?
  public let cover: String
  public let coverTMDB: String
  public let seasonNumber: Int
  public let coverBig: String
  public let releaseDate: String?
  public let duration: String?

  enum CodingKeys: String, CodingKey {
    case name
    case episodeCount = "episode_count"
    case overview
    case airDate = "air_date"
    case cover
    case coverTMDB = "cover_tmdb"
    case seasonNumber = "season_number"
    case coverBig = "cover_big"
    case releaseDate
    case duration
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.episodeCount = try? container.decodeIfPresent(FlexibleString.self, forKey: .episodeCount)
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
    self.airDate = try container.decodeIfPresent(String.self, forKey: .airDate)
    self.cover = try container.decode(String.self, forKey: .cover)
    self.coverTMDB = try container.decode(String.self, forKey: .coverTMDB)
    self.seasonNumber = try container.decodeIfPresent(Int.self, forKey: .seasonNumber) ?? 0
    self.coverBig = try container.decode(String.self, forKey: .coverBig)
    self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
  }
}

// Informations complètes sur une série
public struct SeriesDetail: Decodable {
  public let info: SeriesInfo
  public let seasons: [Season]
  public let episodes: [String: [Episode]]?

  enum CodingKeys: String, CodingKey {
    case info
    case seasons
    case episodes
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.info = try container.decode(SeriesInfo.self, forKey: .info)
    self.seasons = try container.decodeIfPresent([Season].self, forKey: .seasons) ?? []
    self.episodes = try? container.decodeIfPresent([String: [Episode]].self, forKey: .episodes)
  }

  public init(info: SeriesInfo, seasons: [Season], episodes: [String: [Episode]]?) {
    self.info = info
    self.seasons = seasons
    self.episodes = episodes
  }
}
