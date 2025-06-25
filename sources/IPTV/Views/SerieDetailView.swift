//
//  SerieDetailView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 14/11/2024.
//

import IPTVComponents
import IPTVModels
import RealmSwift
import SwiftUI

struct SerieDetailView: View {
  @Namespace var mainNamespace
  @State var showDescription = false
  @State var streamId: Int
  @State var serieDetail: SeriesDetail?
  @State var urlTmdbString: String?
  @State private var showPlayer: Bool = false
  @State private var selectedStreamURL: URL? = nil

  @ObservedResults(CachedSeries.self) var series

  var filteredSerie: CachedSeries? {
    series.where { $0.id == streamId }.first
  }

  private let ratio: CGFloat = 250 / 150
  private let column: Int = 6

  private func allEpisodes(_: String) -> [Episode] {
    guard let serieDetail, let values = serieDetail.episodes?.values else {
      return []
    }
    return values.flatMap { $0 }
  }

  private var allEpisodes: [Episode] {
    guard let serieDetail, let values = serieDetail.episodes?.values else {
      return []
    }
    return values.flatMap { $0 }
  }

  private func allEpisodes(for saison: Int) -> [Episode] {
    return allEpisodes.filter { $0.season == saison }
  }

  @State var allSeasons: [Int] = []

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        if let filteredSerie {
          Text("\(String(describing: filteredSerie.name))")
            .font(.largeTitle)
            .bold()

          Spacer()
          GeometryReader { geometry in
            ScrollView(.vertical) {
              VStack(spacing: 12) {
                Text(filteredSerie.genre ?? "")
                  .font(.caption.bold())
                  .foregroundStyle(Color.white)
                  .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .top, spacing: 30) {
                  VStack(spacing: 12) {
                    Button {
                    } label: {
                      Image(systemName: "heart")
                    }
                  }
                  .frame(width: geometry.frame(in: .global).width * 0.1)

                  Button {
                    showDescription = true
                  } label: {
                    Text(serieDetail?.info.plot ?? "")
                      .font(.callout)
                      .lineLimit(5)
                      .foregroundStyle(Color.white)
                  }
                  .buttonStyle(.plain)
                  .frame(width: geometry.frame(in: .global).width * 0.6)

                  VStack(spacing: 0) {
                    Text("Starring : ")
                      .foregroundStyle(Color.white)
                      + Text(filteredSerie.cast ?? "")
                      .foregroundStyle(Color.white)
                      + Text("\nDirector : ")
                      .foregroundStyle(Color.white)
                      + Text(filteredSerie.director ?? "")
                      .foregroundStyle(Color.white)
                  }
                }
                makeSeasons()
              }
              .padding(.top)
            }
          }
        } else {
          EmptyView()
        }
      }
      .padding(16)
      .background {
        if serieDetail != nil {
          // let backdropPaths = serieDetail.info.backdropPaths
          if let urlTmdbString, let urlBack = URL(string: urlTmdbString) {
            backgroundImage(urlBack: urlBack)
          } /* else if !backdropPaths.isEmpty,  let urlBack = URL(string: backdropPaths[0]) {
           backgroundImage(urlBack: urlBack)
           } */ else {
            HeroHeaderView(belowFold: true)
          }
        }
      }
      .sheet(isPresented: $showDescription) {
        VStack(alignment: .center) {
          Text(serieDetail?.info.plot ?? "")
            .font(.callout)
            .foregroundStyle(.black)
            .frame(maxWidth: 600)
            .background(.white)
        }
      }
      .fullScreenCover(isPresented: Binding(get: {
        showPlayer && selectedStreamURL != nil
      }, set: { showPlayer = $0 })) {
        if let streamURL = selectedStreamURL {
          ViewPlayerContent(mediaURL: streamURL, id: currentID, kind: .series)
            .ignoresSafeArea()
        }
      }
    }
    .onAppear {
      Task {
        await viewDidLoad()
      }
    }
  }

  private func viewDidLoad() async {
    serieDetail = try? await loadSerieDetail()
    if let stream = filteredSerie {
      urlTmdbString = await stream.getTmdbImage()
    }
    allSeasons = allEpisodes
      .compactMap(\.season)
      .unique()
      .sorted()
      .reversed()
  }

  @State private var currentID: Int = 9999

  @ViewBuilder
  private func makeSeasons() -> some View {
    if !allSeasons.isEmpty {
      ForEach(allSeasons, id: \.self) { season in
        Section {
          LazyVStack(spacing: 16) {
            LazyHStack {
              Text("SAISON \(season)")
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .font(.system(size: 23, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.horizontal) {
              LazyHStack(spacing: 16) {
                ForEach(allEpisodes(for: season), id: \.id) { episode in
                  customButton(episode)
                    .id("shelf_\(episode.season)_\(episode.episodeNum)")
                }
              }
            }
            .id("shelf_\(season)")
            .scrollClipDisabled()
            .buttonStyle(.borderless)
          }
        }
        .padding(.vertical, 48)
        .id("saison_\(season)")
      }
    }
  }

  @ViewBuilder
  private func customButton(_ episode: Episode) -> some View {
    CustomButton(action: {
      currentID = Int(episode.id) ?? 9999
      selectedStreamURL = URL(string: episode.streamURL())
      showPlayer = true
    }, longPressAction: {
    }) {
      VStack(alignment: .leading) {
        VStack(spacing: 16) {
          if let imageUrl = episode.info?.movieImage, let url = URL(string: imageUrl) {
            AsyncImage(url: url, placeholder: {
              Rectangle()
                .foregroundColor(.white.opacity(0.5))
                .opacity(0.2)
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 150)
            }, content: { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 150)
            })
          } else {
            Image("beach_portrait", bundle: .main)
              .foregroundColor(.white.opacity(0.5))
              .opacity(0.2)
              .aspectRatio(contentMode: .fill)
              .frame(width: 250, height: 150)
          }
        }

        Text(episode.title.replacingOccurrences(of: filteredSerie?.name ?? "", with: ""))
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .foregroundStyle(.white)
          .font(.system(size: 14))
          .frame(width: 250)
          .frame(maxHeight: 48)
          .padding(0)
          .background(Color.black.opacity(0.5))
      }
      .aspectRatio(ratio, contentMode: .fit)
      .containerRelativeFrame(.horizontal, count: column, spacing: 48)
    }
#if os(tvOS)
    .prefersDefaultFocus(in: mainNamespace)
#endif
    .id(episode.id)
  }

  @ViewBuilder
  private func placeholder() -> some View {
    Rectangle()
      .foregroundColor(.black)
      .opacity(0.2)
      .aspectRatio(ratio, contentMode: .fit)
      .containerRelativeFrame(.horizontal, count: column, spacing: 40)
  }

  @ViewBuilder private func backgroundImage(urlBack: URL) -> some View {
    AsyncImage(url: urlBack, placeholder: {
      Rectangle()
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }, content: { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(alignment: .top)
        .overlay {
          Rectangle()
            .fill(.black)
            .mask {
              LinearGradient(
                stops: [
                  .init(color: .black, location: 0.2),
                  .init(color: .black, location: 0.3),
                  .init(color: .black, location: 0.4),
                  .init(color: .black.opacity(0.5), location: 0.5),
                  .init(color: .black.opacity(0.2), location: 0.6),
                  .init(color: .black.opacity(0), location: 1),
                ],
                startPoint: .bottom, endPoint: .top
              )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
  }

  private func loadSerieDetail() async throws -> SeriesDetail {
    let apiURL = "\(APIManager.shared.baseURL)&action=get_series_info&series_id=\(streamId)"
    return try await withCheckedThrowingContinuation { continuation in
      APIManager.shared.fetchSeriesDetails(from: apiURL) { result in
        switch result {
        case let .success(streams):
          continuation.resume(returning: streams)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
