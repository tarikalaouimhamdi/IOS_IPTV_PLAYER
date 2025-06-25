//
//  BlurView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 14/11/2024.
//

import Foundation
import SwiftUI

#if os(macOS)

@available(macOS 11, *)
public struct BlurView: NSViewRepresentable {
  public typealias NSViewType = NSVisualEffectView

  public func makeNSView(context _: Context) -> NSVisualEffectView {
    let effectView = NSVisualEffectView()
    effectView.material = .hudWindow
    effectView.blendingMode = .withinWindow
    effectView.state = NSVisualEffectView.State.active
    return effectView
  }

  public func updateNSView(_ nsView: NSVisualEffectView, context _: Context) {
    nsView.material = .hudWindow
    nsView.blendingMode = .withinWindow
  }
}

#else

@available(iOS 14, *)
public struct BlurView: UIViewRepresentable {
  public typealias UIViewType = UIVisualEffectView

  public func makeUIView(context _: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: .regular))
  }

  public func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
    uiView.effect = UIBlurEffect(style: .regular)
  }
}

#endif

#if os(macOS)
@available(macOS 11, *)
struct ActivityIndicator: NSViewRepresentable {
  let color: Color

  func makeNSView(context: NSViewRepresentableContext<ActivityIndicator>) -> NSProgressIndicator {
    let nsView = NSProgressIndicator()

    nsView.isIndeterminate = true
    nsView.style = .spinning
    nsView.startAnimation(context)

    return nsView
  }

  func updateNSView(_: NSProgressIndicator, context _: NSViewRepresentableContext<ActivityIndicator>) {
  }
}
#else
@available(iOS 14, *)
struct ActivityIndicator: UIViewRepresentable {
  let color: Color

  func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    let progressView = UIActivityIndicatorView(style: .large)
    progressView.startAnimating()

    return progressView
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>) {
    uiView.color = UIColor(color)
  }
}
#endif
