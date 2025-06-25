//
//  Thumbnail.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//

import Alamofire
import SwiftUI

struct Thumbnail: View {
  var imageUrl: URL
  var ratio: CGFloat
  var column: Int = 6
  var contentMode: ContentMode = .fill
  @State var isVisible: Bool = false

  var body: some View {
    VStack {
      if isVisible {
        AsyncImage(
          url: imageUrl,
          content: { image in
            if contentMode == .fit {
              image
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)

            } else {
              image
                .renderingMode(.original)
                .resizable()
                .aspectRatio(ratio, contentMode: .fit)
                .containerRelativeFrame(.horizontal, count: column, spacing: 40)
            }
          },
          placeholder: {
            placeholder()
          }
        )
      } else {
        placeholder()
      }
    }
    .onAppear {
      isVisible = true
    }
    .onDisappear {
      isVisible = false
    }
    .aspectRatio(ratio, contentMode: .fit)
    .containerRelativeFrame(.horizontal, count: column, spacing: 40)
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
