//
//  ImageCache.swift
//
//
//  Created by Tarik ALAOUI on 11/05/2022.
//

import UIKit

public protocol ImageCache {
  subscript(_: URL) -> UIImage? { get set }
}

public class TemporaryImageCache: ImageCache {
  @MainActor static let shared = TemporaryImageCache()

  private let cache: NSCache<NSURL, UIImage> = {
    let cache = NSCache<NSURL, UIImage>()
    cache.countLimit = 1500 // 100 items
    cache.totalCostLimit = 1024 * 1024 * 300 // 100 MB
    return cache
  }()

  public subscript(_ key: URL) -> UIImage? {
    get { cache.object(forKey: key as NSURL) }
    set {
      guard let newValue else {
        cache.removeObject(forKey: key as NSURL)
        return
      }
      cache.setObject(newValue, forKey: key as NSURL)
    }
  }
}

public class TemporaryFileImageCache: ImageCache {
  @MainActor static let shared = TemporaryFileImageCache()

  private let fileManager: FileManager
  private let cacheDirectory: URL
  private let maxCacheSize: UInt64 = 200 * 1024 * 1024 // 100 MB

  init() {
    self.fileManager = FileManager.default

    // Créer un dossier temporaire spécifique pour le cache des images
    let tempDirectory = fileManager.temporaryDirectory
    self.cacheDirectory = tempDirectory.appendingPathComponent(
      "ImageCache",
      isDirectory: true
    )

    // Créer le dossier si nécessaire
    if !fileManager.fileExists(atPath: cacheDirectory.path) {
      do {
        try fileManager.createDirectory(
          at: cacheDirectory,
          withIntermediateDirectories: true,
          attributes: nil
        )
      } catch {
        print(
          "Erreur lors de la création du dossier ImageCache : \(error)"
        )
      }
    }
  }

  public subscript(_ key: URL) -> UIImage? {
    get {
      let fileURL = cacheDirectory.appendingPathComponent(
        key.lastPathComponent
      )
      guard fileManager.fileExists(atPath: fileURL.path) else {
        return nil
      }

      do {
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
      } catch {
        print("Erreur lors de la lecture du fichier cache : \(error)")
        return nil
      }
    }
    set {
      let fileURL = cacheDirectory.appendingPathComponent(
        key.lastPathComponent
      )

      // Supprimer l'image si la valeur est `nil`
      if newValue == nil {
        do {
          try fileManager.removeItem(at: fileURL)
        } catch {
          print(
            "Erreur lors de la suppression du fichier cache : \(error)"
          )
        }
        return
      }

      // Sauvegarder l'image dans le cache
      guard let data = newValue?.pngData() else { return }
      do {
        try data.write(to: fileURL, options: .atomic)
        enforceCacheSizeLimit()
      } catch {
        print("Erreur lors de l'écriture du fichier cache : \(error)")
      }
    }
  }

  /// Supprime les fichiers les plus anciens si la taille totale du cache dépasse la limite définie
  private func enforceCacheSizeLimit() {
    do {
      let contents = try fileManager.contentsOfDirectory(
        at: cacheDirectory,
        includingPropertiesForKeys: [
          .contentModificationDateKey, .fileSizeKey,
        ],
        options: []
      )

      // Calculer la taille totale du cache
      var totalSize: UInt64 = 0
      var fileAttributes: [(url: URL, size: UInt64, date: Date)] = []

      for fileURL in contents {
        let attributes = try fileManager.attributesOfItem(
          atPath: fileURL.path
        )
        let fileSize = attributes[.size] as? UInt64 ?? 0
        let modificationDate =
          attributes[.modificationDate] as? Date ?? Date()

        totalSize += fileSize
        fileAttributes.append(
          (url: fileURL, size: fileSize, date: modificationDate)
        )
      }

      // Si la taille totale dépasse la limite, supprimer les fichiers les plus anciens
      if totalSize > maxCacheSize {
        let sortedFiles = fileAttributes.sorted(by: {
          $0.date < $1.date
        })
        for file in sortedFiles {
          try fileManager.removeItem(at: file.url)
          totalSize -= file.size
          if totalSize <= maxCacheSize {
            break
          }
        }
      }
    } catch {
      print(
        "Erreur lors de l'enforcement de la limite de taille du cache : \(error)"
      )
    }
  }

  func clearCache() {
    do {
      let contents = try fileManager.contentsOfDirectory(
        at: cacheDirectory,
        includingPropertiesForKeys: nil,
        options: []
      )
      for fileURL in contents {
        try fileManager.removeItem(at: fileURL)
      }
    } catch {
      print(
        "Erreur lors de la suppression des fichiers du cache : \(error)"
      )
    }
  }
}
