//
//  UserInfo.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 19/11/2024.
//
import Foundation

public struct UserInfo: Decodable {
  public let username: String
  public let password: String
  public let message: String
  public let auth: Int
  public let status: String
  public let expDate: Date
  public let isTrial: Bool
  public let activeCons: Int
  public let createdAt: Date
  public let maxConnections: Int
  public let allowedOutputFormats: [String]

  enum CodingKeys: String, CodingKey {
    case username, password, message, auth, status
    case expDate = "exp_date"
    case isTrial = "is_trial"
    case activeCons = "active_cons"
    case createdAt = "created_at"
    case maxConnections = "max_connections"
    case allowedOutputFormats = "allowed_output_formats"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.username = try container.decode(String.self, forKey: .username)
    self.password = try container.decode(String.self, forKey: .password)
    self.message = try container.decode(String.self, forKey: .message)
    self.auth = try container.decode(Int.self, forKey: .auth)
    self.status = try container.decode(String.self, forKey: .status)
    let expDateString = try container.decode(String.self, forKey: .expDate)
    self.expDate = Date(timeIntervalSince1970: TimeInterval(expDateString) ?? 0)
    let isTrialString = try container.decode(String.self, forKey: .isTrial)
    self.isTrial = isTrialString == "1"
    let activeConsString = try container.decode(String.self, forKey: .activeCons)
    self.activeCons = Int(activeConsString) ?? 0
    let createdAtString = try container.decode(String.self, forKey: .createdAt)
    self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtString) ?? 0)
    let maxConnectionsString = try container.decode(String.self, forKey: .maxConnections)
    self.maxConnections = Int(maxConnectionsString) ?? 0
    self.allowedOutputFormats = try container.decode([String].self, forKey: .allowedOutputFormats)
  }
}

public struct InfoUserResponse: Decodable {
  public let userInfo: UserInfo
  public let serverInfo: ServerInfo

  enum CodingKeys: String, CodingKey {
    case userInfo = "user_info"
    case serverInfo = "server_info"
  }
}
