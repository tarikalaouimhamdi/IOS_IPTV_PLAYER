//
//  LiveUseCase.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 23/12/2024.
//
import IPTVComponents
import IPTVInterfaces
import IPTVModels
import SwiftUI

final class LiveUseCase: ObservableObject {
  public var kindMedia: KindMedia

  @Published var showErrorAlert: Bool = false
  @Published var errorMessage: String = ""

  private var cacheManager: CacheManagerProtocol
  private var apiManager: APIManagerProtocol

  init(
    kindMedia: KindMedia,
    apiManager: APIManagerProtocol,
    cacheManager: CacheManagerProtocol
  ) {
    self.kindMedia = kindMedia
    self.apiManager = apiManager
    self.cacheManager = cacheManager
  }

  func loadCategories() async {
    do {
      let fetchedCategories = await fetchLiveCategories()
      await cacheManager.cacheCategories(fetchedCategories, for: kindMedia.rawValue)

      for category in fetchedCategories {
        let streams = try await loadStreams(for: category.id)

        await MainActor.run {
          cacheManager.cacheStreams(streams, for: kindMedia.rawValue)
        }
      }
    } catch {
      await MainActor.run {
        errorMessage = error.localizedDescription
        showErrorAlert = true
      }
    }
  }

  func fetchLiveCategories() async -> [IPTVModels.Category] {
    return await withCheckedContinuation { continuation in
      let liveURL = URL(string: "\(APIManager.shared.baseURL)&action=get_live_categories")!
      apiManager.fetchCategories(from: liveURL) { result in
        switch result {
        case let .success(categories):
          continuation.resume(returning: categories)
        case let .failure(error):
          print("Erreur API: \(error)")
          continuation.resume(returning: [])
        }
      }
    }
  }

  private func loadStreams(for categoryId: String) async throws -> [IPTVModels.Stream] {
    let apiURL = "\(APIManager.shared.baseURL)&action=get_live_streams&category_id=\(categoryId)"
    return try await withCheckedThrowingContinuation { continuation in
      apiManager.fetchStreams(for: apiURL) { result in
        switch result {
        case let .success(streams):
          continuation.resume(returning: streams)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
