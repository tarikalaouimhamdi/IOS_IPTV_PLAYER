//
//  ContentView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import IPTVComponents
import IPTVModels
import Realm
import SwiftUI

struct ContentView: View {
  @AppStorage("status") private var status: String = ""

  var body: some View {
    if $status.wrappedValue != "" {
      TabView {
        Tab("Live", systemImage: "tv") {
          LiveView(kindMedia: .live)
        }
        Tab("VOD", systemImage: "film") {
          VodView(kindMedia: .vod)
        }
        Tab("Séries", systemImage: "square.stack") {
          SeriesView(kindMedia: .series)
        }
        Tab("Search", systemImage: "magnifyingglass") {
          SearchView()
        }
        Tab("Settings", systemImage: "gear") {
          SettingsView()
            .background {
              HeroHeaderView(belowFold: true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
      }
      .background {
        HeroHeaderView(belowFold: true)
      }
    } else {
      SettingsView()
        .background {
          HeroHeaderView(belowFold: true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}

#Preview {
  ContentView()
}
