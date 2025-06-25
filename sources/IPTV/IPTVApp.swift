//
//  IPTVApp.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 10/11/2024.
//

import SwiftUI

@main
struct IPTVApp: App {
#if os(iOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
#endif

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
