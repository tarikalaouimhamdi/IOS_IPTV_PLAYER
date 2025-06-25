//
//  SearchView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 12/11/2024.
//

import IPTVComponents
import IPTVModels
import RealmSwift
import SwiftUI

let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 40), count: 4)

struct SearchView: View {
  @State var searchTerm: String = ""
  @State var effectiveSearch: String = ""

  @ObservedResults(CachedStream.self) var streams: Results<CachedStream>
  @ObservedResults(CachedSeries.self) var series: Results<CachedSeries>

  @State private var searchTask: Task<Void, Never>?
  @State private var showPlayer: Bool = false
  @State private var selectedStreamURL: URL? = nil

  @State private var showSerieDetail: Bool = false
  @State private var selectedSerieId: Int? = nil

  var filteredVods: Results<CachedStream> {
    let searchWords = "*\(effectiveSearch.replacingOccurrences(of: " ", with: "*"))*"
    return streams.where {
      $0.section == KindMedia.vod.rawValue && $0.name.like(searchWords, caseInsensitive: true)
    }
  }

  var filteredLives: Results<CachedStream> {
    let searchWords = "*\(effectiveSearch.replacingOccurrences(of: " ", with: "*"))*"
    return streams.where {
      $0.section == KindMedia.live.rawValue && $0.name.like(searchWords, caseInsensitive: true)
    }
  }

  var filteredSeries: Results<CachedSeries> {
    let searchWords = "*\(effectiveSearch.replacingOccurrences(of: " ", with: "*"))*"
    return series.where {
      $0.section == KindMedia.series.rawValue && $0.name.like(searchWords, caseInsensitive: true)
    }
  }

  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        LazyVStack(alignment: .trailing, spacing: 36) {
          if !filteredVods.isEmpty {
            MovieSearchShelf(streams: filteredVods, kindMedia: .vod) { stream in
              selectedStreamURL = URL(string: stream.streamURL())
              showPlayer = true
            }
          }

          if !filteredLives.isEmpty {
            LiveSearchShelf(streams: filteredLives, kindMedia: .live) { stream in
              currentID = Int(stream.id)
              selectedStreamURL = URL(string: stream.streamURL())
              showPlayer = true
            }
          }

          if !filteredSeries.isEmpty {
            SeriesSearchShelf(streams: filteredSeries, kindMedia: .series) { stream in
              currentID = Int(stream.id)
              selectedSerieId = stream.id
              showSerieDetail = true
            }
          }
        }
        .buttonStyle(.borderless)
      }
      .background {
        HeroHeaderView(belowFold: true)
      }
      .scrollClipDisabled()
      .searchable(text: $searchTerm)
      .searchSuggestions {
      }
      .fullScreenCover(isPresented: Binding(get: {
        showPlayer && selectedStreamURL != nil
      }, set: { showPlayer = $0 })) {
        if let streamURL = selectedStreamURL {
          ViewPlayerContent(mediaURL: streamURL, id: currentID, kind: .vod)
            .ignoresSafeArea()
        }
      }
      .navigationDestination(isPresented: Binding(get: {
        showSerieDetail && selectedSerieId != nil
      }, set: { showSerieDetail = $0 })) {
        if let selectedSerieId {
          SerieDetailView(streamId: selectedSerieId)
        }
      }
      .onChange(of: searchTerm) {
        handleSearchDebounced(for: $searchTerm.wrappedValue)
      }
    }
  }

  @State private var currentID: Int = 9999

  private func handleSearchDebounced(for text: String) {
    searchTask?.cancel()

    searchTask = Task {
      try? await Task.sleep(nanoseconds: 300 * 1_000_000) // 300ms
      guard !Task.isCancelled else { return }

      await searchContent(text)
    }
  }

  private func searchContent(_ text: String) async {
    guard !text.isEmpty, text.count >= 2 else {
      effectiveSearch = ""
      return
    }

    effectiveSearch = text
  }
}
