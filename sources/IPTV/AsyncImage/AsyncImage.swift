//
//  AsyncImage.swift
//
//
//  Created by Tarik ALAOUI on 11/05/2022.
//

import SwiftUI

public struct AsyncImage<Content: View, Placeholder: View>: View {
  @Environment(\.redactionReasons) private var redactionReasons

  @StateObject private var loader: ImageLoader
  private let placeholder: Placeholder
  private let content: (Image) -> Content
  private let url: URL

  public init(
    url: URL,
    @ViewBuilder placeholder: () -> Placeholder,
    @ViewBuilder content: @escaping (Image) -> Content
  ) {
    self.url = url
    self.placeholder = placeholder()
    self.content = content
    _loader = StateObject(
      wrappedValue: ImageLoader(
        cache: TemporaryFileImageCache.shared
      )
    )
  }

  public init(url: URL, @ViewBuilder placeholder: () -> Placeholder) where Content == Image {
    self.url = url
    self.placeholder = placeholder()
    self.content = { $0 }
    _loader = StateObject(
      wrappedValue: ImageLoader(
        cache: TemporaryFileImageCache.shared
      )
    )
  }

  public var body: some View {
    Group {
      if isRedacted {
        Rectangle().fill(Color.black).opacity(0.2)
      } else {
        if let image = loader.image {
          content(Image(uiImage: image))
        } else {
          placeholder
        }
      }
    }
    .onChange(of: url, initial: false) {
      Task(priority: .utility) {
        await loader.load(url)
      }
    }
    .task {
      await loader.load(url)
    }
  }

  private var isRedacted: Bool {
    redactionReasons.contains(.placeholder)
  }
}

// swiftlint:disable force_unwrapping
struct AsyncImage_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AsyncImage(
        url: URL(string: "https://alaoui.me/assets/images/profile-img.jpg")!,
        placeholder: {
          Text("Placeholder")
        },
        content: { image in
          image
            .resizable()
            .scaledToFill()
        }
      )
      .frame(width: 400, height: 200)
      .clipped()
    }
  }
}
