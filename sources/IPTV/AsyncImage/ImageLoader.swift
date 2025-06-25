//
//  ImageLoader.swift
//
//
//  Created by Tarik ALAOUI on 11/05/2022.
//

import Combine
import IPTVComponents
import UIKit

class ImageLoader: ObservableObject {
  // MARK: - Contants

  private enum Constants {
    static let httpStatusCodeRangeAvailability = (200 ..< 300)
  }

  @Published var image: UIImage?
  private var cache: ImageCache?

  init(cache: ImageCache? = nil) {
    self.cache = cache
  }

  func load(_ url: URL) async {
    if let image = cache?[url] {
      await update(image: image)
      return
    }

    await withCheckedContinuation { continuation in
      APIManager.shared.fetchData(from: url) { result in
        switch result {
        case let .success(data):
          if let image = UIImage(data: data) {
            self.cache(url, image: image)
            Task { await self.update(image: image) }
          } else {
            Task { await self.update(image: nil) }
          }
        case .failure:
          Task { await self.update(image: nil) }
        }
        continuation.resume()
      }
    }
  }

  @MainActor
  private func update(image: UIImage?) async {
    self.image = image
  }

  private func cache(_ url: URL, image: UIImage?) {
    image.map { cache?[url] = $0 }
  }
}
