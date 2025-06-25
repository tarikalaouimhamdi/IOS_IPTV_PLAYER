//
//  APIManagerProtocol.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 23/12/2024.
//

import Foundation
import IPTVModels

/// sourcery: AutoMockableIPTV
public protocol APIManagerProtocol {
  var baseURL: String { get }
  var liveURL: String { get }
  var vodURL: String { get }
  var serieURL: String { get }

  func fetchCategories(from url: URL, completion: @escaping (Result<[IPTVModels.Category], Error>) -> Void)
  func fetchStreams(for categoryAPI: String, completion: @escaping (Result<[IPTVModels.Stream], Error>) -> Void)
  func fetchSeries(for categoryAPI: String, completion: @escaping (Result<[Series], Error>) -> Void)
  func fetchSeriesDetails(from urlString: String, completion: @escaping (Result<SeriesDetail, Error>) -> Void)
  func fetchInfoUser(from urlString: String, completion: @escaping (Result<InfoUserResponse, Error>) -> Void)
  func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
