//
//  AppConfig.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 25/06/2025.
//
import Foundation

enum AppConfig {
  // MARK: - Public config keys
  
  static var tmpdbApiKey: String {
    string(for: "TMDB_API_KEY")
  }
  
  static var apiHost: String {
    string(for: "API_HOST")
  }

  static var apiPassword: String {
    string(for: "API_PASSWORD")
  }

  static var apiLogin: String {
    string(for: "API_LOGIN")
  }

  // MARK: - Helper Methods
  
  private static func string(for key: String) -> String {
    guard let str = Bundle.main.infoDictionary?[key] as? String else { return "" }
    return str
  }
}
