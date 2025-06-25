//
//  MovieShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import IPTVModels
import RealmSwift
import SwiftUI

public struct MovieShelf: View {
  @Namespace var mainNamespace
  private let ratio: CGFloat = 250 / 375
  private let column: Int = 6

  public var category: CategoryEntity
  public var kindMedia: KindMedia
  public var categoryId: String = "-1"
  @State private var addToFavori: Bool = false

  var openStream: (CachedStream) -> Void
  @ObservedResults(CachedStream.self) var streams: Results<CachedStream>

  var filteredStreams: Results<CachedStream> {
    streams.where { $0.section == kindMedia.rawValue && $0.categoryId == categoryId }
      .sorted(by: \.year, ascending: false)
  }

  public init(category: CategoryEntity, kindMedia: KindMedia, openStream: @escaping (CachedStream) -> Void) {
    self.category = category
    self.kindMedia = kindMedia
    self.openStream = openStream
    self.categoryId = category.id
  }

  @MainActor
  private func addFavori(stream: CachedStream) async {
    do {
      let realm = try await Realm()
      try realm.write {
        let favori = FavoriEntity(
          id: stream.id,
          kind: kindMedia.rawValue,
          name: stream.name,
          streamIcon: stream.streamIcon,
          added: Date(),
          tmdb: stream.tmdb
        )
        realm.add(favori)
      }
      addToFavori = true
    } catch {
      print("Erreur lors de la sauvegarde dans SwiftData: \(error)")
    }
  }

  public var body: some View {
    VStack {
      sectionHeader()
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(filteredStreams) { stream in
            CustomButton(
              action: {
                DispatchQueue.main.async {
                  openStream(stream)
                }
              }, longPressAction: {
                Task {
                  await addFavori(stream: stream)
                }
              }
            ) {
              ZStack(alignment: .bottom) {
                if let imageUrl = stream.getImage(), let url = URL(string: imageUrl) {
                  Thumbnail(imageUrl: url, ratio: ratio, column: column)
                } else {
                  placeholder()
                }

                Text(stream.name.formatted())
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

            .id(stream.id)
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
}
