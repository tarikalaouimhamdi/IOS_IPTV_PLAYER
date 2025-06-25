//
//  String+extension.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 13/11/2024.
//

import Foundation

public extension String {
  func formatted() -> String {
    let keywords = ["[FR]", "|FR|", "[MA]", "[TN]", "|AR|", "|MA|", "|TN|", "|EU| ", "VOD - ", "SRS - ", "FR - ", "TN - ", "MA - ", "FR: "]
    var nameFor: String = self
    keywords.forEach { keyword in
      nameFor = nameFor.replacingOccurrences(of: keyword, with: "")
    }

    return nameFor
  }

  func sanitizeSearchTerm() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
  }
}
