//
//  ViewPlayerContent.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//
import Foundation
import IPTVModels
import SwiftUI

struct ViewPlayerContent: View {
  @State private var isPlaying: Bool = false
  @State private var mediaURL: URL
  @State private var id: Int
  @State private var kind: KindMedia

  public init(mediaURL: URL, id: Int, kind: KindMedia) {
    self.mediaURL = mediaURL
    self.id = id
    self.kind = kind
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      VideoPlayerView(streamURL: mediaURL, id: id, kind: kind)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea(edges: .all)
    .background(.black)
  }
}
