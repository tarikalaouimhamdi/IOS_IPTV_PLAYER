//
//  SerieShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import IPTVModels
import RealmSwift
import SwiftUI

public struct SerieShelf: View {
  @Namespace var mainNamespace
  private let ratio: CGFloat = 250 / 375
  private let column: Int = 6

  public var category: CategoryEntity
  public var kindMedia: KindMedia
  @State private var addToFavori: Bool = false

  var openStream: (CachedSeries) -> Void
  @ObservedResults(CachedSeries.self) var streams: Results<CachedSeries>

  public var categoryId: String = "-1"

  public init(category: CategoryEntity, kindMedia: KindMedia, openStream: @escaping (CachedSeries) -> Void) {
    self.category = category
    self.kindMedia = kindMedia
    self.openStream = openStream
    self.categoryId = category.id
  }

  var filteredStreams: Results<CachedSeries> {
    streams.where { $0.section == kindMedia.rawValue && $0.categoryID == categoryId }
      .sorted(by: \.lastModified, ascending: false)
  }

  public var body: some View {
    VStack {
      sectionHeader()
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(filteredStreams) { serie in
            customButton(serie)
          }
        }
      }
      .scrollClipDisabled()
      .buttonStyle(.borderless)
    }
    .toast(isPresenting: $addToFavori, duration: 3) {
      AlertToast(type: .regular, title: "Ajouté au favori")
    }
  }

  @ViewBuilder
  private func customButton(_ serie: CachedSeries) -> some View {
    CustomButton(action: {
      openStream(serie)
    }, longPressAction: {
      Task {
        await addFavori(serie: serie)
      }
    }) {
      ZStack(alignment: .bottom) {
        if let imageUrl = serie.getImage(), let url = URL(string: imageUrl) {
          Thumbnail(imageUrl: url, ratio: ratio, column: column)
        } else {
          placeholder()
        }

        Text(serie.name.formatted())
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .foregroundStyle(.white)
          .font(.system(size: 14))
          .frame(maxWidth: .infinity, maxHeight: 64)
          .background(Color.black.opacity(0.5))
      }
      .aspectRatio(ratio, contentMode: .fit)
      .containerRelativeFrame(.horizontal, count: column, spacing: 40)
    }
#if TARGET_OS_TV
    .prefersDefaultFocus(in: mainNamespace)
#endif
    .id(serie.id)
  }

  @ViewBuilder
  private func sectionHeader() -> some View {
    HStack {
      Text("\(filteredStreams.count) x \(category.name.formatted())")
        .lineLimit(4)
        .multilineTextAlignment(.center)
        .font(.system(size: 23, weight: .bold))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  @ViewBuilder
  private func placeholder() -> some View {
    Rectangle()
      .foregroundColor(.black)
      .opacity(0.2)
      .aspectRatio(ratio, contentMode: .fit)
      .containerRelativeFrame(.horizontal, count: column, spacing: 40)
  }

  @MainActor
  private func addFavori(serie: CachedSeries) async {
    do {
      let realm = try await Realm()
      try realm.write {
        let favori = FavoriEntity(
          id: serie.id,
          kind: kindMedia.rawValue,
          name: serie.name,
          streamIcon: serie.cover,
          added: Date(),
          tmdb: serie.tmdb
        )
        realm.add(favori)
      }
      addToFavori = true
    } catch {
      print("Erreur lors de la sauvegarde dans SwiftData: \(error)")
    }
  }
}
