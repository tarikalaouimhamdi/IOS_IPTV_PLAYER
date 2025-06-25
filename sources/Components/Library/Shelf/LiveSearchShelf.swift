//
//  LiveSearchShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import IPTVModels
import RealmSwift
import SwiftUI

public struct LiveSearchShelf: View {
  @Namespace var mainNamespace

  private let ratio: CGFloat = 250 / 150
  private let column: Int = 6

  public var kindMedia: KindMedia

  var streams: Results<CachedStream>

  var openStream: (CachedStream) -> Void

  public init(streams: Results<CachedStream>, kindMedia: KindMedia, openStream: @escaping (CachedStream) -> Void) {
    self.kindMedia = kindMedia
    self.openStream = openStream
    self.streams = streams
  }

  private func removeStream(_ stream: FavoriEntity) {
    let realm = try! Realm()
    realm.delete(stream)
  }

  @MainActor
  private func addFavori(stream: CachedStream) async {
    do {
      let realm = try await Realm()

      let favori = FavoriEntity(
        id: stream.id,
        kind: kindMedia.rawValue,
        name: stream.name,
        streamIcon: stream.streamIcon,
        added: Date(),
        tmdb: stream.tmdb
      )
      realm.add(favori)
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
            customButton(stream)
          }
        }
      }
      .scrollClipDisabled()
      .buttonStyle(.borderless)
    }
  }

  @ViewBuilder
  private func customButton(_ stream: CachedStream) -> some View {
    CustomButton(action: {
      DispatchQueue.main.async {
        openStream(stream)
      }
    }, longPressAction: {
      Task {
        await addFavori(stream: stream)
      }
    }) {
      ZStack(alignment: .center) {
        if let imageUrl = stream.getImage(), let url = URL(string: imageUrl) {
          Thumbnail(imageUrl: url, ratio: ratio, column: column, contentMode: .fit)
            .padding(.vertical, 18)
        } else {
          placeholder()
            .padding(.vertical, 18)
        }
        Spacer()
        VStack {
          Spacer()
          Text(stream.name.formatted())
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, maxHeight: 28)
            .background(Color.black.opacity(0.2))
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.black.opacity(0.2))
      .cornerRadius(8)
      .aspectRatio(ratio, contentMode: .fit)
      .containerRelativeFrame(.horizontal, count: column, spacing: 40)
    }
#if TARGET_OS_TV
    .prefersDefaultFocus(in: mainNamespace)
#endif
    .id(stream.id)
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
