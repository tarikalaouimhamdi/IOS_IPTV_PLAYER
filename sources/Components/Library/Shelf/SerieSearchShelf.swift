//
//  SeriesSearchShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import Foundation
import IPTVModels
import RealmSwift
import SwiftUI

public struct SeriesSearchShelf: View {
  @Namespace var mainNamespace
  private let ratio: CGFloat = 250 / 375
  private let column: Int = 6

  public var kindMedia: KindMedia

  var openStream: (CachedSeries) -> Void
  var streams: Results<CachedSeries>

  public init(streams: Results<CachedSeries>, kindMedia: KindMedia, openStream: @escaping (CachedSeries) -> Void) {
    self.streams = streams
    self.kindMedia = kindMedia
    self.openStream = openStream
  }

  public var body: some View {
    VStack {
      sectionHeader()
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(streams) { serie in
            customButton(serie)
          }
        }
      }
      .scrollClipDisabled()
      .buttonStyle(.borderless)
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
      Text("\(streams.count) x SERIES")
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
    } catch {
      print("Erreur lors de la sauvegarde dans SwiftData: \(error)")
    }
  }
}
