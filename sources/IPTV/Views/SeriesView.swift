import IPTVComponents
import IPTVModels
import RealmSwift
import SwiftUI

public struct SeriesView: View {
  @State private var showPlayer: Bool = false
  @State private var selectedStreamURL: URL?
  @State private var streamSelected: Int?

  @State private var showErrorAlert: Bool = false
  @State private var errorMessage: String = ""

  @State var progress: Double = 0.0
  @State var isLoading: Bool = false

  private let kindMedia: KindMedia
  @ObservedResults(CategoryEntity.self, where: ({ $0.section == KindMedia.series.rawValue })) var categories

  public init(kindMedia: KindMedia) {
    self.kindMedia = kindMedia
  }

  public var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(alignment: .trailing, spacing: 36) {
          HStack {
            refreshButton
              .padding(.bottom, 16)
              .disabled(isLoading)

            if isLoading {
              ProgressView()
                .progressViewStyle(.circular)
            }
          }
          makeSectionFavori()
          ForEach(categories, id: \.id) { category in
            makeSection(for: category)
          }
        }
        .padding(.horizontal)
      }
      .background {
        HeroHeaderView(belowFold: true)
      }
      .alert("Erreur", isPresented: $showErrorAlert) {
        Button("OK", role: .cancel) {
        }
      } message: {
        Text(errorMessage)
      }
      .navigationDestination(isPresented: $showPlayer, destination: {
        if let streamSelected {
          SerieDetailView(streamId: streamSelected)
        }
      })
    }
  }

  private var refreshButton: some View {
    Button("Rafraîchir") {
      isLoading = true
      Task.detached(priority: .background) {
        await loadCategories()
      }
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
  }

  @ViewBuilder
  private func makeSectionFavori() -> some View {
    Section {
      FavoriSerieShelf(kindMedia: kindMedia) { stream in
        streamSelected = stream.id
        showPlayer = true
      }
    }
  }

  @ViewBuilder
  private func makeSection(for category: CategoryEntity) -> some View {
    Section {
      SerieShelf(category: category, kindMedia: kindMedia) { stream in
        streamSelected = stream.id
        showPlayer = true
      }
    }
  }

  private func loadCategories() async {
    do {
      let fetchedCategories = try await fetchCategories()

      await CacheManager.shared.cacheCategories(fetchedCategories, for: kindMedia.rawValue)

      for category in fetchedCategories {
        let series = try await loadSeries(for: category.id)

        await MainActor.run {
          CacheManager.shared.cacheSeries(series, for: kindMedia.rawValue)
        }
      }

      await MainActor.run {
        isLoading = false
      }
    } catch {
      await MainActor.run {
        errorMessage = error.localizedDescription
        showErrorAlert = true
        isLoading = false
      }
    }
  }

  private func fetchCategories() async throws -> [IPTVModels.Category] {
    let action = "get_series_categories"

    let liveURL = URL(string: "\(APIManager.shared.baseURL)&action=\(action)")!
    return try await withCheckedThrowingContinuation { continuation in
      APIManager.shared.fetchCategories(from: liveURL) { result in
        switch result {
        case let .success(categories):
          continuation.resume(returning: categories)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  private func loadSeries(for categoryId: String) async throws -> [Series] {
    let action = "get_series"

    let apiURL = "\(APIManager.shared.baseURL)&action=\(action)&category_id=\(categoryId)"
    return try await withCheckedThrowingContinuation { continuation in
      APIManager.shared.fetchSeries(for: apiURL) { result in
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

#Preview {
  VodView(kindMedia: .vod)
}
