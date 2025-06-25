//
//  UIView+resize.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 05/02/2025.
//
import SwiftUI
import UIKit

extension UIView {
  /// attaches all sides of the receiver to its parent view
  func coverWholeSuperview(margin: CGFloat = 0.0) {
    let view = superview
    layoutAttachTop(to: view, margin: margin)
    layoutAttachBottom(to: view, margin: margin)
    layoutAttachLeading(to: view, margin: margin)
    layoutAttachTrailing(to: view, margin: margin)
  }

  /// attaches the top of the current view to the given view's top if it's a superview of the current view
  /// or to it's bottom if it's not (assuming this is then a sibling view).
  @discardableResult
  func layoutAttachTop(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
    let view: UIView? = to ?? superview
    let isSuperview = view == superview
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: .top,
      relatedBy: .equal,
      toItem: view,
      attribute: isSuperview ? .top : .bottom,
      multiplier: 1.0,
      constant: margin
    )
    superview?.addConstraint(constraint)

    return constraint
  }

  /// attaches the bottom of the current view to the given view
  @discardableResult
  func layoutAttachBottom(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
    let view: UIView? = to ?? superview
    let isSuperview = (view == superview) || false
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: view,
      attribute: isSuperview ? .bottom : .top,
      multiplier: 1.0,
      constant: -margin
    )
    if let priority {
      constraint.priority = priority
    }
    superview?.addConstraint(constraint)

    return constraint
  }

  /// attaches the leading edge of the current view to the given view
  @discardableResult
  func layoutAttachLeading(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {
    let view: UIView? = to ?? superview
    let isSuperview = (view == superview) || false
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: .leading,
      relatedBy: .equal,
      toItem: view,
      attribute: isSuperview ? .leading : .trailing,
      multiplier: 1.0,
      constant: margin
    )
    superview?.addConstraint(constraint)

    return constraint
  }

  /// attaches the trailing edge of the current view to the given view
  @discardableResult
  func layoutAttachTrailing(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
    let view: UIView? = to ?? superview
    let isSuperview = (view == superview) || false
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: view,
      attribute: isSuperview ? .trailing : .leading,
      multiplier: 1.0,
      constant: -margin
    )
    if let priority {
      constraint.priority = priority
    }
    superview?.addConstraint(constraint)

    return constraint
  }

  // for anchoring View
  struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height, centerX, centerY: NSLayoutConstraint?
  }

  @discardableResult
  func constraints(
    top: NSLayoutYAxisAnchor? = nil,
    leading: NSLayoutXAxisAnchor? = nil,
    bottom: NSLayoutYAxisAnchor? = nil,
    trailing: NSLayoutXAxisAnchor? = nil,
    padding: UIEdgeInsets = .zero,
    size: CGSize = .zero,
    centerX: NSLayoutXAxisAnchor? = nil,
    centerY: NSLayoutYAxisAnchor? = nil,
    centerXOffset: CGFloat = 0,
    centerYOffset: CGFloat = 0
  ) -> AnchoredConstraints {
    translatesAutoresizingMaskIntoConstraints = false
    var anchoredConstraints = AnchoredConstraints()

    if let top {
      anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
    }

    if let leading {
      anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
    }

    if let bottom {
      anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
    }

    if let trailing {
      anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
    }

    if size.width != 0 {
      anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
    }

    if size.height != 0 {
      anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
    }

    if let centerX {
      anchoredConstraints.centerX = centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset)
    }

    if let centerY {
      anchoredConstraints.centerY = centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset)
    }

    [
      anchoredConstraints.top,
      anchoredConstraints.leading,
      anchoredConstraints.bottom,
      anchoredConstraints.trailing,
      anchoredConstraints.width,
      anchoredConstraints.height,
      anchoredConstraints.centerX,
      anchoredConstraints.centerY,
    ].forEach { $0?.isActive = true }

    return anchoredConstraints
  }
}
