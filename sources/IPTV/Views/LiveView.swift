//
//  LiveView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import IPTVComponents
import IPTVModels
import RealmSwift
import SwiftUI

public struct LiveView: View {
  @ObservedObject var useCase: LiveUseCase
  @State private var belowFold = false
  private var showcaseHeight: CGFloat = 800

  @State private var selectedCategory: String? = nil
  @State private var showPlayer: Bool = false
  @State private var selectedStreamURL: URL? = nil

  @State private var showErrorAlert: Bool = false
  @State private var errorMessage: String = ""

  public var kindMedia: KindMedia

  @ObservedResults(CategoryEntity.self, where: ({ $0.section == KindMedia.live.rawValue })) var categories

  public init(kindMedia: KindMedia) {
    self.kindMedia = kindMedia
    self.useCase = LiveUseCase(
      kindMedia: kindMedia,
      apiManager: APIManager.shared,
      cacheManager: CacheManager.shared
    )
  }

  public var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        LazyVStack(alignment: .trailing, spacing: 36) {
          HStack {
            Button("Rafraichir") {
              Task(priority: .background) {
                await useCase.loadCategories()
              }
            }
          }

          makeSectionFavori()

          ForEach(categories, id: \.id) { category in
            makeSection(for: category)
          }
          .frame(maxWidth: .infinity)

          if categories.count == 0 {
            VStack(alignment: .center) {
              Spacer()
              Text("Charger la liste des chaines !")
              Spacer()
            }
            .frame(height: 500)
            .frame(maxWidth: .infinity, alignment: .center)
          }
        }
        .padding(.horizontal)
      }
      .background(alignment: .top) {
        HeroHeaderView(belowFold: true)
      }
      .frame(maxHeight: .infinity, alignment: .top)
      .alert("Erreur", isPresented: $useCase.showErrorAlert) {
        Button("OK", role: .cancel) {
        }
      } message: {
        Text(errorMessage)
      }
      .fullScreenCover(isPresented: Binding(get: {
        showPlayer && selectedStreamURL != nil
      }, set: { showPlayer = $0 })) {
        GeometryReader { _ in
          ViewPlayerContent(mediaURL: selectedStreamURL!, id: currentID, kind: .live)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
      }
    }
  }

  @State private var currentID: Int = 9999

  @ViewBuilder
  private func makeSectionFavori() -> some View {
    Section {
      FavoriLiveShelf(kindMedia: kindMedia) { stream in
        currentID = stream.id
        selectedStreamURL = URL(string: stream.streamURL())
        showPlayer = true
      }
    }
  }

  @ViewBuilder
  func makeSection(for category: CategoryEntity) -> some View {
    Section {
      LiveShelf(category: category, kindMedia: kindMedia) { stream in
        currentID = stream.id
        selectedStreamURL = URL(string: stream.streamURL())
        showPlayer = true
      }
    }
    .id(category.id)
  }
}
