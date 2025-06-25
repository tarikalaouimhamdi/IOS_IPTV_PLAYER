//
//  FavoriMovieShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import IPTVModels
import RealmSwift
import SwiftUI

public struct FavoriMovieShelf: View {
  @Namespace var mainNamespace
  private let ratio: CGFloat = 250 / 375
  private let column: Int = 6

  public var kindMedia: KindMedia

  @ObservedResults(FavoriEntity.self, where: ({ $0.kind == KindMedia.vod.rawValue })) var streams

  var openStream: (FavoriEntity) -> Void

  public init(kindMedia: KindMedia, openStream: @escaping (FavoriEntity) -> Void) {
    self.kindMedia = kindMedia
    self.openStream = openStream
  }

  @MainActor
  private func removeStream(_ stream: FavoriEntity) {
    let realm = try! Realm()
    if let obj = realm.objects(FavoriEntity.self).first(where: { $0.id == stream.id }) {
      do {
        try realm.write {
          realm.delete(obj)
        }
      } catch {
        print("\(error)")
      }
    }
  }

  public var body: some View {
    VStack {
      if streams.count > 0 {
        sectionHeader()
      }
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(streams) { stream in
            CustomButton(
              action: {
                openStream(stream)
              }, longPressAction: {
                removeStream(stream)
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
                  .font(.system(size: 20))
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
      Text("\(streams.count) x FAVORIS")
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
