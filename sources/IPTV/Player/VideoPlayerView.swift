//
//  VideoPlayerView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import AVKit
import IPTVModels
import SwiftUI

struct VideoPlayerView: UIViewControllerRepresentable {
  @State private var isPlaying: Bool = false
  let streamURL: URL
  let id: Int
  let kind: KindMedia

  @MainActor
  func makeUIViewController(context _: Context) -> UIViewController {
    let controller = VPlayerController()
    controller.setupPlayer(with: streamURL, id: id, kind: kind)
    controller.modalPresentationStyle = .fullScreen
    controller.additionalSafeAreaInsets = .zero
    return controller
  }

  func updateUIViewController(_: VPlayerController, context _: Context) {
  }

  func updateUIViewController(_: UIViewController, context _: Context) {
  }

  func makeUIView(context _: Context) -> UIView {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    view.coverWholeSuperview()
    return view
  }
}
