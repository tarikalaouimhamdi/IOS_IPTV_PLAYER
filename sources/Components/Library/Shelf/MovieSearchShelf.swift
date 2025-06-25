//
//  MovieSearchShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import IPTVModels
import RealmSwift
import SwiftUI

public struct MovieSearchShelf: View {
  @Namespace var mainNamespace
  private let ratio: CGFloat = 250 / 375
  private let column: Int = 6
  public var kindMedia: KindMedia

  var streams: Results<CachedStream>

  var openStream: (CachedStream) -> Void

  public init(streams: Results<CachedStream>, kindMedia: KindMedia, openStream: @escaping (CachedStream) -> Void) {
    self.kindMedia = kindMedia
    self.openStream = openStream
    self.streams = streams
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
    } catch {
      print("Erreur lors de la sauvegarde dans SwiftData: \(error)")
    }
  }

  public var body: some View {
    VStack {
      sectionHeader()
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(streams) { stream in
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
                  Thumbnail(imageUrl: url, ratio: ratio, column: column, contentMode: kindMedia == .live ? .fit : .fill)
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
  }

  @ViewBuilder
  private func sectionHeader() -> some View {
    HStack {
      Text("\(streams.count) x \(kindMedia.rawValue.uppercased())")
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
