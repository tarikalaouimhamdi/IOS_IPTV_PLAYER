//
//  LiveShelf.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import IPTVModels
import RealmSwift
import SwiftUI

public struct LiveShelf: View {
  @Namespace var mainNamespace

  private let ratio: CGFloat = 250 / 150
  private let column: Int = 6

  public var category: CategoryEntity
  public var categoryId: String = "-1"
  @State private var kindMedia: KindMedia
  @State private var addToFavori: Bool = false

  @ObservedResults(CachedStream.self) var streams: Results<CachedStream>

  var openStream: (CachedStream) -> Void

  public init(category: CategoryEntity, kindMedia: KindMedia, openStream: @escaping (CachedStream) -> Void) {
    self.category = category
    self.kindMedia = kindMedia
    self.openStream = openStream
    self.categoryId = category.id
  }

  var filteredStreams: Results<CachedStream> {
    streams.where { $0.section == kindMedia.rawValue && $0.categoryId == categoryId }
  }

  public var body: some View {
    VStack {
      sectionHeader()
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(filteredStreams) { stream in
            customButton(stream)
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
            .background(.white.opacity(0.5))
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
