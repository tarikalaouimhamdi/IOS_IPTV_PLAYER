#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 14.0, *)
internal struct Snackbar: View {
  @Binding var isShowing: Bool
  private let presenting: AnyView
  private let title: Text
  private let text: Text?
  private let style: SnackbarStyle
  private let actionText: String?
  private let action: (() -> Void)?
  private let extraBottomPadding: CGFloat
  private let viewOffset: CGFloat = 6
  private let dismissOnTap: Bool
  private let dismissAfter: Double?

  internal init(isShowing: Binding<Bool>, presenting: some View, title: Text, text: Text?, style: SnackbarStyle, extraBottomPadding: CGFloat, actionText: String? = nil, action: (() -> Void)? = nil, dismissOnTap: Bool = true, dismissAfter: Double? = 4) {
    _isShowing = isShowing
    self.presenting = AnyView(presenting)
    self.title = title
    self.text = text
    self.style = style
    self.actionText = actionText
    self.action = action
    self.extraBottomPadding = extraBottomPadding
    self.dismissOnTap = dismissOnTap
    self.dismissAfter = dismissAfter
  }

  internal init(isShowing: Binding<Bool>, presenting: some View, title: String, text: String?, style: SnackbarStyle, extraBottomPadding: CGFloat, actionText: String? = nil, action: (() -> Void)? = nil, dismissOnTap: Bool = true, dismissAfter: Double? = 4) {
    _isShowing = isShowing
    self.presenting = AnyView(presenting)
    self.title = Text(title)
    self.text = text != nil ? Text(text!) : nil
    self.style = style
    self.actionText = actionText
    self.action = action
    self.extraBottomPadding = extraBottomPadding
    self.dismissOnTap = dismissOnTap
    self.dismissAfter = dismissAfter
  }

  internal var body: some View {
    ZStack {
      presenting

      VStack {
        Spacer()
        snackbar
      }
      .ignoresSafeArea()
    }
  }

  private var snackbar: some View {
    VStack {
      Spacer()
      if isShowing {
        HStack {
          VStack(alignment: .leading, spacing: 3) {
            title
              .fontWeight(.semibold)
            if let text {
              text
            }
          }
          .font(.system(.body, design: .rounded))
          .foregroundColor(textColor)
          .padding(.bottom, text == nil ? 23 : 0)

          Spacer()

          if hasAction {
            Text(actionText!)
              .bold()
              .textCase(.uppercase)
              .foregroundColor(textColor)
              .onTapGesture {
                action?()
                withAnimation {
                  isShowing = false
                }
              }
          }
        }
        .padding(.top)
        .padding(.horizontal, 24)
        .padding(.bottom, 32 + viewOffset + extraBottomPadding)
        .background(backgroundColor)
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: isShowing)
        .onAppear {
//                    guard !hasAction else { return }
          if let dismissAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
              withAnimation {
                isShowing = false
              }
            }
          }
        } //: onAppear
        .onTapGesture {
          if dismissOnTap {
            isShowing = false
          }
        } //: onTapGesture
      }
    } //: VStack
    .offset(y: viewOffset)
  }

  private var hasAction: Bool {
    actionText != nil && action != nil
  }

  private var backgroundColor: Color {
    switch style {
    case .default:
      return .accentColor
    case .warning:
      return Color("Warning", bundle: .main)
    case .error:
      return Color("Error", bundle: .main)
    case let .custom(color: color):
      return color
    }
  }

  private var textColor: Color {
    if backgroundColor.isDark {
      return .white
    }
    return .black
  }
}
