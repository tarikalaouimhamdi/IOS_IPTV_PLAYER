//
//  CustomButton.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 12/11/2024.
//
import SwiftUI

public struct CustomButton<Content>: View where Content: View {
  @State
  private var focused = false
  @State
  private var pressed = false

  public let action: () -> Void
  public let longPressAction: () -> Void

  @ViewBuilder
  public let content: () -> Content

  public init(focused: Bool = false, pressed: Bool = false, action: @escaping () -> Void, longPressAction: @escaping () -> Void, content: @escaping () -> Content) {
    self.focused = focused
    self.pressed = pressed
    self.action = action
    self.longPressAction = longPressAction
    self.content = content
  }

  public var body: some View {
    contentView
      .background(focused ? .white.opacity(0.5) : .clear.opacity(0.5))
      .cornerRadius(8)
      .scaleEffect(pressed || focused ? 1.1 : 1)
      .animation(.linear(duration: 0.2), value: focused)
      .animation(.default, value: pressed)
  }

  var contentView: some View {
#if os(tvOS)
    ZStack {
      ClickableHack(focused: $focused, pressed: $pressed, action: action)
        .onLongPressGesture(minimumDuration: 0.3) {
          longPressAction()
        }
        .onTapGesture {
          action()
        }
      content()
        .padding(8)
        .layoutPriority(1)
    }
#else
    Button(action: action, label: content)
#endif
  }
}

class ClickableHackView: UIView {
  weak var delegate: ClickableHackDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    if validatePress(event: event) {
      delegate?.pressesBegan()
    } else {
      super.pressesBegan(presses, with: event)
    }
  }

  override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    if validatePress(event: event) {
      delegate?.pressesEnded()
    } else {
      super.pressesEnded(presses, with: event)
    }
  }

  override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    if validatePress(event: event) {
      delegate?.pressesEnded()
    } else {
      super.pressesCancelled(presses, with: event)
    }
  }

  private func validatePress(event: UIPressesEvent?) -> Bool {
    event?.allPresses.map(\.type).contains(.select) ?? false
  }

  override func didUpdateFocus(in _: UIFocusUpdateContext, with _: UIFocusAnimationCoordinator) {
    delegate?.focus(focused: isFocused)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var canBecomeFocused: Bool {
    return true
  }
}

protocol ClickableHackDelegate: AnyObject {
  func focus(focused: Bool)
  func pressesBegan()
  func pressesEnded()
}

struct ClickableHack: UIViewRepresentable {
  @Binding var focused: Bool
  @Binding var pressed: Bool
  let action: () -> Void

  func makeUIView(context: UIViewRepresentableContext<ClickableHack>) -> UIView {
    let clickableView = ClickableHackView()
    clickableView.delegate = context.coordinator
    return clickableView
  }

  func updateUIView(_: UIView, context _: UIViewRepresentableContext<ClickableHack>) {
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  class Coordinator: NSObject, @preconcurrency ClickableHackDelegate {
    private let control: ClickableHack

    init(_ control: ClickableHack) {
      self.control = control
      super.init()
    }

    @MainActor
    func focus(focused: Bool) {
      control.focused = focused
    }

    @MainActor
    func pressesBegan() {
      control.pressed = true
    }

    @MainActor
    func pressesEnded() {
      control.pressed = false
      // control.action()
    }
  }
}
