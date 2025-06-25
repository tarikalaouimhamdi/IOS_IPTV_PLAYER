//
//  ServerInfo.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 19/11/2024.
//
import Foundation

public struct ServerInfo: Decodable {
  public let url: String
  public let port: String
  public let httpsPort: String
  public let serverProtocol: String
  public let rtmpPort: String
  public let timezone: String
  public let timestampNow: Int
  public let timeNow: String
  public let process: Bool?

  enum CodingKeys: String, CodingKey {
    case url, port, timezone, process
    case httpsPort = "https_port"
    case serverProtocol = "server_protocol"
    case rtmpPort = "rtmp_port"
    case timestampNow = "timestamp_now"
    case timeNow = "time_now"
  }
}
