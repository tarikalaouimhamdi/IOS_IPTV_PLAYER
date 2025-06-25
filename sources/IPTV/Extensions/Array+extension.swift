//
//  Array+extension.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 11/11/2024.
//
import Foundation
import IPTVModels

extension [IPTVModels.Stream] {
  func sortedByDateDescending() -> [IPTVModels.Stream] {
    sorted { $0.added > $1.added }
  }
}

extension [Series] {
  func sortedByDateDescending() -> [Series] {
    sorted { $0.lastModified > $1.lastModified }
  }
}

extension Array where Element: Hashable {
  func unique() -> [Element] {
    return Array(Set(self))
  }
}
