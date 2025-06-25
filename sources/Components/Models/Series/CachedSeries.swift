//
//  CachedSeries.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 12/11/2024.
//

import RealmSwift
import SwiftUI

public class CachedSeries: Object, ObjectKeyIdentifiable {
  @Persisted public var _identifier: ObjectId
  @Persisted(primaryKey: true) public var id: Int
  @Persisted public var name: String
  @Persisted public var seriesID: Int
  @Persisted public var cover: String?
  @Persisted public var plot: String?
  @Persisted public var cast: String?
  @Persisted public var director: String?
  @Persisted public var genre: String?
  @Persisted public var releaseDate: String?
  @Persisted public var lastModified: Date
  @Persisted public var rating: Double?
  @Persisted public var rating5Based: Double?
  @Persisted public var backdropPaths: Data?
  @Persisted public var youtubeTrailer: String?
  @Persisted public var tmdb: String
  @Persisted public var episodeRunTime: Int
  @Persisted public var categoryID: String
  @Persisted public var categoryIDs: Data?
  @Persisted public var section: String
  @Persisted public var isFavorite: Bool

  public var kindMedia: KindMedia {
    KindMedia(rawValue: section) ?? .vod
  }

  public convenience init(serie: Series, section: String) {
    self.init()
    self.id = serie.id
    self.name = serie.name
    self.seriesID = serie.seriesID
    self.cover = serie.cover
    self.plot = serie.plot
    self.cast = serie.cast
    self.director = serie.director
    self.genre = serie.genre
    self.releaseDate = serie.releaseDate
    self.lastModified = serie.lastModified
    self.rating = serie.rating
    self.rating5Based = serie.rating5Based
    self.backdropPaths = serie.backdropPathsData
    self.youtubeTrailer = serie.youtubeTrailer
    self.tmdb = serie.tmdb ?? ""
    self.episodeRunTime = 0 // serie.episodeRunTime?.value
    self.categoryID = serie.categoryID
    self.categoryIDs = serie.categoryIDsData
    self.section = section
    self.isFavorite = false
  }

  public func getImage() -> String? {
    return cover
  }
}

// MARK: SeriesInfo

public class SeriesInfoEntity: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) public var _identifier: ObjectId
  @Persisted public var name: String
  @Persisted public var cover: String
  @Persisted public var plot: String?
  @Persisted public var cast: String?
  @Persisted public var director: String?
  @Persisted public var genre: String?
  @Persisted public var releaseDate: String?
  @Persisted public var lastModified: Date?
  @Persisted public var rating: Double
  @Persisted public var rating5Based: Double
  @Persisted public var tmdb: String
  @Persisted public var youtubeTrailer: String?

  override public class func primaryKey() -> String? {
    return "tmdb"
  }

  public convenience init(name: String, cover: String, plot: String? = nil, cast: String? = nil, director: String? = nil, genre: String? = nil, releaseDate: String? = nil, lastModified: Date? = nil, rating: Double, rating5Based: Double, tmdb: String, youtubeTrailer: String? = nil) {
    self.init()
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
    self.youtubeTrailer = youtubeTrailer
  }
}

// Informations sur un épisode
public class EpisodeEntity: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) public var id: String
  @Persisted public var episodeNum: Int
  @Persisted public var title: String
  @Persisted public var containerExtension: String?
  @Persisted public var added: Date?
  @Persisted public var season: Int
  @Persisted public var infoID: Int
  @Persisted public var movieImage: String?

  public convenience init(id: String, episodeNum: Int, title: String, containerExtension: String? = nil, added: Date? = nil, season: Int, infoID: Int, movieImage: String? = nil) {
    self.init()
    self.id = id
    self.episodeNum = episodeNum
    self.title = title
    self.containerExtension = containerExtension
    self.added = added
    self.season = season
    self.infoID = infoID
    self.movieImage = movieImage
  }
}

// Informations sur une saison
public class SeasonEntity: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) public var _identifier: ObjectId
  @Persisted public var name: String
  @Persisted public var episodeCount: Int
  @Persisted public var overview: String?
  @Persisted public var airDate: String?
  @Persisted public var cover: String
  @Persisted public var coverTMDB: String
  @Persisted public var seasonNumber: Int
  @Persisted public var coverBig: String
  @Persisted public var releaseDate: String?
  @Persisted public var duration: String?

  public convenience init(name: String, episodeCount: Int, overview: String? = nil, airDate: String? = nil, cover: String, coverTMDB: String, seasonNumber: Int, coverBig: String, releaseDate: String? = nil, duration: String? = nil) {
    self.init()
    self._identifier = _identifier
    self.name = name
    self.episodeCount = episodeCount
    self.overview = overview
    self.airDate = airDate
    self.cover = cover
    self.coverTMDB = coverTMDB
    self.seasonNumber = seasonNumber
    self.coverBig = coverBig
    self.releaseDate = releaseDate
    self.duration = duration
  }
}

// Informations complètes sur une série
public class SerieDetailEntity: Object {
  @Persisted(primaryKey: true) public var id: String
  @Persisted public var info: SeriesInfoEntity?
  @Persisted public var seasons: RealmSwift.List<SeasonEntity>
  @Persisted public var episodes: RealmSwift.List<EpisodeEntity>

  public convenience init(id: String, info: SeriesInfoEntity? = nil, seasons: RealmSwift.List<SeasonEntity>, episodes: RealmSwift.List<EpisodeEntity>) {
    self.init()
    self.id = id
    self.info = info
    self.seasons = seasons
    self.episodes = episodes
  }
}
