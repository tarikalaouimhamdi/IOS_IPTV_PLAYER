//
//  CacheManager.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import Foundation
import IPTVInterfaces
import IPTVModels
import RealmSwift
import SwiftUI

class CacheManager: CacheManagerProtocol {
  static let shared = CacheManager()

  public init() {
    print(Realm.Configuration.defaultConfiguration.fileURL!)
  }

  @MainActor
  func cacheCategories(_ categories: [IPTVModels.Category], for section: String) async {
    let realm = try! await Realm()
    do {
      try realm.write {
        for category in categories {
          let categoryCached = CategoryEntity(
            id: category.id,
            name: category.name,
            parentId: category.parentId,
            section: section
          )

          realm.add(categoryCached, update: .modified)
        }
      }
    } catch {
      print("Erreur lors de la sauvegarde dans Realm: \(error)")
    }
  }

  func cacheStreams(_ streams: [IPTVModels.Stream], for section: String) {
    let realm = try! Realm()
    do {
      try realm.write {
        for stream in streams {
          let cachedStream = CachedStream(
            id: stream.id,
            name: stream.name,
            streamType: stream.streamType,
            streamIcon: stream.streamIcon,
            section: section,
            added: stream.added,
            categoryId: stream.categoryId,
            rating: stream.rating,
            desc: stream.description,
            tmdb: stream.tmdb?.value,
            year: stream.year,
            containerExtension: stream.containerExtension
          )
          realm.add(cachedStream, update: .modified)
        }
      }
    } catch {
      print("Erreur lors de la sauvegarde dans Realm: \(error)")
    }
  }

  func resetDatabase() {
    let realm = try! Realm()
    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch {
      print("Erreur lors de la sauvegarde dans Realm: \(error)")
    }
  }

  func cacheSeries(_ series: [Series], for section: String) {
    let realm = try! Realm()
    do {
      try realm.write {
        for serie in series {
          let cachedSerie = CachedSeries(serie: serie, section: section)
          realm.add(cachedSerie, update: .modified)
        }
      }
    } catch {
      print("Erreur lors de la sauvegarde dans Realm: \(error)")
    }
  }

  // Récupère les catégories d'une section depuis la base de données
  func fetchCachedCategories(for section: String) -> [CategoryEntity] {
    // Utilisation de la requête SwiftData
    return fetchFilteredCategories(for: section)
  }

  // Récupère les catégories d'une section depuis la base de données
  func fetchCachedStream(for section: String, categoryId: String) -> [IPTVModels.Stream] {
    do {
      let realm = try Realm()
      let streams = realm.objects(CachedStream.self)
      let results = streams.where { $0.section == section && $0.categoryId == categoryId }

      return results.map {
        IPTVModels.Stream(
          id: $0.id,
          name: $0.name,
          streamType: $0.streamType,
          streamIcon: $0.streamIcon,
          categoryId: $0.categoryId,
          rating: $0.rating,
          description: $0.desc,
          tmdb: FlexibleString(from: $0.tmdb),
          added: $0.added,
          year: $0.year
        )
      }
    } catch {
      print("Erreur lors de la récupération des streams : \(error)")
      return []
    }
  }

  func fetchFilteredCategories(for section: String) -> [CategoryEntity] {
    do {
      let realm = try Realm()
      let categories = realm.objects(CategoryEntity.self)
      let results = categories.where { $0.section == section && ($0.name.contains("[FR]") || $0.name.contains("|FR|") || $0.name.contains("FRANCE")) }

      return results.map(\.self)
    } catch {
      print("Erreur lors de la récupération des catégories : \(error)")
      return []
    }
  }
}
