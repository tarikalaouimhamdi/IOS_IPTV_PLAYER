// Generated using Sourcery 1.5.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
// swiftlint:disable vertical_whitespace

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import SwiftUI
import XCTest
#elseif os(OSX)
import AppKit
#endif

@testable import IPTV

import Combine
private func objectDidNotCallAnyMethod(_ object: Any) -> Bool {
    let mirror = Mirror(reflecting: object)
    for case let (label?, value) in mirror.children where label.hasSuffix("CallsCount") {
        if let count = value as? Int, count > 0 {
            return false
        }
    }
    return true
}

private func objectDidNotCallAnyMethod(_ object: Any, except methodName: String) -> Bool {
    let mirror = Mirror(reflecting: object)
    for case let (label?, value) in mirror.children where label.hasSuffix("CallsCount") {
        let methodCallsCountName = methodName + "CallsCount"
        if let count = value as? Int, (label == methodCallsCountName && count == 0) || (label != methodCallsCountName && count > 0) { return false }
    }
    return true
}

private func calledStringMethods(in object: Any) -> [String] {
    var methods: [String] = []
    let mirror = Mirror(reflecting: object)
    for case let (label?, value) in mirror.children where label.hasSuffix("CallsCount") {
        let callsCount = (value as? Int) ?? 0
        if callsCount > 0 {
            let methodName = label.replacingOccurrences(of: "CallsCount", with: "")
            methods.append(methodName)
        }
    }
    return methods
}

private func objectDidNotCallAnyMethod(_ object: Any, except methodsNames: [String]) -> Bool {
    let calledStringsMethodsSet = Set(calledStringMethods(in: object))
    let methodsNamesSet = Set(methodsNames)
    return calledStringsMethodsSet.count == methodsNamesSet.count &&
        methodsNamesSet.isSubset(of: calledStringsMethodsSet)
}

class APIManagerProtocolMock {
    var baseURL: String {
        get { return underlyingBaseURL }
        set(value) { underlyingBaseURL = value }
    }

    var underlyingBaseURL: String!
    var liveURL: String {
        get { return underlyingLiveURL }
        set(value) { underlyingLiveURL = value }
    }

    var underlyingLiveURL: String!
    var vodURL: String {
        get { return underlyingVodURL }
        set(value) { underlyingVodURL = value }
    }

    var underlyingVodURL: String!
    var serieURL: String {
        get { return underlyingSerieURL }
        set(value) { underlyingSerieURL = value }
    }

    var underlyingSerieURL: String!

    // MARK: - fetchCategories

    lazy var fetchCategoriesFromCompletionExpectation: XCTestExpectation = .init(description: "fetchCategoriesFromCompletion")
    var fetchCategoriesFromCompletionCallsCount: Int = 0
    var fetchCategoriesFromCompletionCalledOnQueueLabel: String?
    var fetchCategoriesFromCompletionCalled: Bool {
        return fetchCategoriesFromCompletionCallsCount > 0
    }

    var fetchCategoriesFromCompletionCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchCategoriesFromCompletion")
    }

    var fetchCategoriesFromCompletionCalledOnlyAndOnce: Bool {
        return fetchCategoriesFromCompletionCalledOnly && fetchCategoriesFromCompletionCallsCount == 1
    }

    var fetchCategoriesFromCompletionReceivedArguments: (url: URL, completion: (Result<[Category], Error>) -> Void)?
    var fetchCategoriesFromCompletionClosure: ((URL, @escaping (Result<[Category], Error>) -> Void) -> Void)?

    // MARK: - fetchStreams

    lazy var fetchStreamsForCompletionExpectation: XCTestExpectation = .init(description: "fetchStreamsForCompletion")
    var fetchStreamsForCompletionCallsCount: Int = 0
    var fetchStreamsForCompletionCalledOnQueueLabel: String?
    var fetchStreamsForCompletionCalled: Bool {
        return fetchStreamsForCompletionCallsCount > 0
    }

    var fetchStreamsForCompletionCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchStreamsForCompletion")
    }

    var fetchStreamsForCompletionCalledOnlyAndOnce: Bool {
        return fetchStreamsForCompletionCalledOnly && fetchStreamsForCompletionCallsCount == 1
    }

    var fetchStreamsForCompletionReceivedArguments: (categoryAPI: String, completion: (Result<[Stream], Error>) -> Void)?
    var fetchStreamsForCompletionClosure: ((String, @escaping (Result<[Stream], Error>) -> Void) -> Void)?

    // MARK: - fetchSeries

    lazy var fetchSeriesForCompletionExpectation: XCTestExpectation = .init(description: "fetchSeriesForCompletion")
    var fetchSeriesForCompletionCallsCount: Int = 0
    var fetchSeriesForCompletionCalledOnQueueLabel: String?
    var fetchSeriesForCompletionCalled: Bool {
        return fetchSeriesForCompletionCallsCount > 0
    }

    var fetchSeriesForCompletionCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchSeriesForCompletion")
    }

    var fetchSeriesForCompletionCalledOnlyAndOnce: Bool {
        return fetchSeriesForCompletionCalledOnly && fetchSeriesForCompletionCallsCount == 1
    }

    var fetchSeriesForCompletionReceivedArguments: (categoryAPI: String, completion: (Result<[Series], Error>) -> Void)?
    var fetchSeriesForCompletionClosure: ((String, @escaping (Result<[Series], Error>) -> Void) -> Void)?

    // MARK: - fetchSeriesDetails

    lazy var fetchSeriesDetailsFromCompletionExpectation: XCTestExpectation = .init(description: "fetchSeriesDetailsFromCompletion")
    var fetchSeriesDetailsFromCompletionCallsCount: Int = 0
    var fetchSeriesDetailsFromCompletionCalledOnQueueLabel: String?
    var fetchSeriesDetailsFromCompletionCalled: Bool {
        return fetchSeriesDetailsFromCompletionCallsCount > 0
    }

    var fetchSeriesDetailsFromCompletionCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchSeriesDetailsFromCompletion")
    }

    var fetchSeriesDetailsFromCompletionCalledOnlyAndOnce: Bool {
        return fetchSeriesDetailsFromCompletionCalledOnly && fetchSeriesDetailsFromCompletionCallsCount == 1
    }

    var fetchSeriesDetailsFromCompletionReceivedArguments: (urlString: String, completion: (Result<SeriesDetail, Error>) -> Void)?
    var fetchSeriesDetailsFromCompletionClosure: ((String, @escaping (Result<SeriesDetail, Error>) -> Void) -> Void)?

    // MARK: - fetchInfoUser

    lazy var fetchInfoUserFromCompletionExpectation: XCTestExpectation = .init(description: "fetchInfoUserFromCompletion")
    var fetchInfoUserFromCompletionCallsCount: Int = 0
    var fetchInfoUserFromCompletionCalledOnQueueLabel: String?
    var fetchInfoUserFromCompletionCalled: Bool {
        return fetchInfoUserFromCompletionCallsCount > 0
    }

    var fetchInfoUserFromCompletionCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchInfoUserFromCompletion")
    }

    var fetchInfoUserFromCompletionCalledOnlyAndOnce: Bool {
        return fetchInfoUserFromCompletionCalledOnly && fetchInfoUserFromCompletionCallsCount == 1
    }

    var fetchInfoUserFromCompletionReceivedArguments: (urlString: String, completion: (Result<InfoUserResponse, Error>) -> Void)?
    var fetchInfoUserFromCompletionClosure: ((String, @escaping (Result<InfoUserResponse, Error>) -> Void) -> Void)?

    // MARK: - fetchData

    lazy var fetchDataFromCompletionExpectation: XCTestExpectation = .init(description: "fetchDataFromCompletion")
    var fetchDataFromCompletionCallsCount: Int = 0
    var fetchDataFromCompletionCalledOnQueueLabel: String?
    var fetchDataFromCompletionCalled: Bool {
        return fetchDataFromCompletionCallsCount > 0
    }

    var fetchDataFromCompletionCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchDataFromCompletion")
    }

    var fetchDataFromCompletionCalledOnlyAndOnce: Bool {
        return fetchDataFromCompletionCalledOnly && fetchDataFromCompletionCallsCount == 1
    }

    var fetchDataFromCompletionReceivedArguments: (url: URL, completion: (Result<Data, Error>) -> Void)?
    var fetchDataFromCompletionClosure: ((URL, @escaping (Result<Data, Error>) -> Void) -> Void)?

    enum MockedMethods: String {
        case fetchCategoriesFromCompletion
        case fetchStreamsForCompletion
        case fetchSeriesForCompletion
        case fetchSeriesDetailsFromCompletion
        case fetchInfoUserFromCompletion
        case fetchDataFromCompletion
    }

    // MARK: - calledOnlyMethods

    func calledOnlyMethods(_ methods: [MockedMethods]) -> Bool {
        objectDidNotCallAnyMethod(self, except: methods.map(\.rawValue))
    }

    // MARK: - noMethodCalled

    var noMethodCalled: Bool {
        return objectDidNotCallAnyMethod(self)
    }

    init(baseURL: String? = nil, liveURL: String? = nil, vodURL: String? = nil, serieURL: String? = nil) {
        self.underlyingBaseURL = baseURL
        self.underlyingLiveURL = liveURL
        self.underlyingVodURL = vodURL
        self.underlyingSerieURL = serieURL
    }
}

extension APIManagerProtocolMock: APIManagerProtocol {
    func fetchCategories(from url: URL, completion: @escaping (Result<[Category], Error>) -> Void) {
        defer {
            fetchCategoriesFromCompletionExpectation.fulfill()
        }
        fetchCategoriesFromCompletionCallsCount += 1
        fetchCategoriesFromCompletionCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchCategoriesFromCompletionReceivedArguments = (url: url, completion: completion)
        fetchCategoriesFromCompletionClosure?(url, completion)
    }

    func fetchStreams(for categoryAPI: String, completion: @escaping (Result<[Stream], Error>) -> Void) {
        defer {
            fetchStreamsForCompletionExpectation.fulfill()
        }
        fetchStreamsForCompletionCallsCount += 1
        fetchStreamsForCompletionCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchStreamsForCompletionReceivedArguments = (categoryAPI: categoryAPI, completion: completion)
        fetchStreamsForCompletionClosure?(categoryAPI, completion)
    }

    func fetchSeries(for categoryAPI: String, completion: @escaping (Result<[Series], Error>) -> Void) {
        defer {
            fetchSeriesForCompletionExpectation.fulfill()
        }
        fetchSeriesForCompletionCallsCount += 1
        fetchSeriesForCompletionCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchSeriesForCompletionReceivedArguments = (categoryAPI: categoryAPI, completion: completion)
        fetchSeriesForCompletionClosure?(categoryAPI, completion)
    }

    func fetchSeriesDetails(from urlString: String, completion: @escaping (Result<SeriesDetail, Error>) -> Void) {
        defer {
            fetchSeriesDetailsFromCompletionExpectation.fulfill()
        }
        fetchSeriesDetailsFromCompletionCallsCount += 1
        fetchSeriesDetailsFromCompletionCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchSeriesDetailsFromCompletionReceivedArguments = (urlString: urlString, completion: completion)
        fetchSeriesDetailsFromCompletionClosure?(urlString, completion)
    }

    func fetchInfoUser(from urlString: String, completion: @escaping (Result<InfoUserResponse, Error>) -> Void) {
        defer {
            fetchInfoUserFromCompletionExpectation.fulfill()
        }
        fetchInfoUserFromCompletionCallsCount += 1
        fetchInfoUserFromCompletionCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchInfoUserFromCompletionReceivedArguments = (urlString: urlString, completion: completion)
        fetchInfoUserFromCompletionClosure?(urlString, completion)
    }

    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        defer {
            fetchDataFromCompletionExpectation.fulfill()
        }
        fetchDataFromCompletionCallsCount += 1
        fetchDataFromCompletionCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchDataFromCompletionReceivedArguments = (url: url, completion: completion)
        fetchDataFromCompletionClosure?(url, completion)
    }
}

class CacheManagerProtocolMock {
    // MARK: - cacheCategories

    lazy var cacheCategoriesForExpectation: XCTestExpectation = .init(description: "cacheCategoriesFor")
    var cacheCategoriesForCallsCount: Int = 0
    var cacheCategoriesForCalledOnQueueLabel: String?
    var cacheCategoriesForCalled: Bool {
        return cacheCategoriesForCallsCount > 0
    }

    var cacheCategoriesForCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "cacheCategoriesFor")
    }

    var cacheCategoriesForCalledOnlyAndOnce: Bool {
        return cacheCategoriesForCalledOnly && cacheCategoriesForCallsCount == 1
    }

    var cacheCategoriesForReceivedArguments: (categories: [Category], section: String)?
    var cacheCategoriesForClosure: (([Category], String) -> Void)?

    // MARK: - cacheStreams

    lazy var cacheStreamsForExpectation: XCTestExpectation = .init(description: "cacheStreamsFor")
    var cacheStreamsForCallsCount: Int = 0
    var cacheStreamsForCalledOnQueueLabel: String?
    var cacheStreamsForCalled: Bool {
        return cacheStreamsForCallsCount > 0
    }

    var cacheStreamsForCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "cacheStreamsFor")
    }

    var cacheStreamsForCalledOnlyAndOnce: Bool {
        return cacheStreamsForCalledOnly && cacheStreamsForCallsCount == 1
    }

    var cacheStreamsForReceivedArguments: (streams: [Stream], section: String)?
    var cacheStreamsForClosure: (([Stream], String) -> Void)?

    // MARK: - cacheSeries

    lazy var cacheSeriesForExpectation: XCTestExpectation = .init(description: "cacheSeriesFor")
    var cacheSeriesForCallsCount: Int = 0
    var cacheSeriesForCalledOnQueueLabel: String?
    var cacheSeriesForCalled: Bool {
        return cacheSeriesForCallsCount > 0
    }

    var cacheSeriesForCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "cacheSeriesFor")
    }

    var cacheSeriesForCalledOnlyAndOnce: Bool {
        return cacheSeriesForCalledOnly && cacheSeriesForCallsCount == 1
    }

    var cacheSeriesForReceivedArguments: (series: [Series], section: String)?
    var cacheSeriesForClosure: (([Series], String) -> Void)?

    // MARK: - fetchCachedCategories

    lazy var fetchCachedCategoriesForExpectation: XCTestExpectation = .init(description: "fetchCachedCategoriesFor")
    var fetchCachedCategoriesForCallsCount: Int = 0
    var fetchCachedCategoriesForCalledOnQueueLabel: String?
    var fetchCachedCategoriesForCalled: Bool {
        return fetchCachedCategoriesForCallsCount > 0
    }

    var fetchCachedCategoriesForCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchCachedCategoriesFor")
    }

    var fetchCachedCategoriesForCalledOnlyAndOnce: Bool {
        return fetchCachedCategoriesForCalledOnly && fetchCachedCategoriesForCallsCount == 1
    }

    var fetchCachedCategoriesForReceivedSection: String?
    var fetchCachedCategoriesForReturnValue: [CategoryEntity]!
    var fetchCachedCategoriesForClosure: ((String) -> [CategoryEntity])?

    // MARK: - fetchCachedStream

    lazy var fetchCachedStreamForCategoryIdExpectation: XCTestExpectation = .init(description: "fetchCachedStreamForCategoryId")
    var fetchCachedStreamForCategoryIdCallsCount: Int = 0
    var fetchCachedStreamForCategoryIdCalledOnQueueLabel: String?
    var fetchCachedStreamForCategoryIdCalled: Bool {
        return fetchCachedStreamForCategoryIdCallsCount > 0
    }

    var fetchCachedStreamForCategoryIdCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchCachedStreamForCategoryId")
    }

    var fetchCachedStreamForCategoryIdCalledOnlyAndOnce: Bool {
        return fetchCachedStreamForCategoryIdCalledOnly && fetchCachedStreamForCategoryIdCallsCount == 1
    }

    var fetchCachedStreamForCategoryIdReceivedArguments: (section: String, categoryId: String)?
    var fetchCachedStreamForCategoryIdReturnValue: [Stream]!
    var fetchCachedStreamForCategoryIdClosure: ((String, String) -> [Stream])?

    // MARK: - fetchFilteredCategories

    lazy var fetchFilteredCategoriesForExpectation: XCTestExpectation = .init(description: "fetchFilteredCategoriesFor")
    var fetchFilteredCategoriesForCallsCount: Int = 0
    var fetchFilteredCategoriesForCalledOnQueueLabel: String?
    var fetchFilteredCategoriesForCalled: Bool {
        return fetchFilteredCategoriesForCallsCount > 0
    }

    var fetchFilteredCategoriesForCalledOnly: Bool {
        return objectDidNotCallAnyMethod(self, except: "fetchFilteredCategoriesFor")
    }

    var fetchFilteredCategoriesForCalledOnlyAndOnce: Bool {
        return fetchFilteredCategoriesForCalledOnly && fetchFilteredCategoriesForCallsCount == 1
    }

    var fetchFilteredCategoriesForReceivedSection: String?
    var fetchFilteredCategoriesForReturnValue: [CategoryEntity]!
    var fetchFilteredCategoriesForClosure: ((String) -> [CategoryEntity])?

    enum MockedMethods: String {
        case cacheCategoriesFor
        case cacheStreamsFor
        case cacheSeriesFor
        case fetchCachedCategoriesFor
        case fetchCachedStreamForCategoryId
        case fetchFilteredCategoriesFor
    }

    // MARK: - calledOnlyMethods

    func calledOnlyMethods(_ methods: [MockedMethods]) -> Bool {
        objectDidNotCallAnyMethod(self, except: methods.map(\.rawValue))
    }

    // MARK: - noMethodCalled

    var noMethodCalled: Bool {
        return objectDidNotCallAnyMethod(self)
    }
}

extension CacheManagerProtocolMock: CacheManagerProtocol {
    func cacheCategories(_ categories: [Category], for section: String) {
        defer {
            cacheCategoriesForExpectation.fulfill()
        }
        cacheCategoriesForCallsCount += 1
        cacheCategoriesForCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        cacheCategoriesForReceivedArguments = (categories: categories, section: section)
        cacheCategoriesForClosure?(categories, section)
    }

    func cacheStreams(_ streams: [Stream], for section: String) {
        defer {
            cacheStreamsForExpectation.fulfill()
        }
        cacheStreamsForCallsCount += 1
        cacheStreamsForCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        cacheStreamsForReceivedArguments = (streams: streams, section: section)
        cacheStreamsForClosure?(streams, section)
    }

    func cacheSeries(_ series: [Series], for section: String) {
        defer {
            cacheSeriesForExpectation.fulfill()
        }
        cacheSeriesForCallsCount += 1
        cacheSeriesForCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        cacheSeriesForReceivedArguments = (series: series, section: section)
        cacheSeriesForClosure?(series, section)
    }

    func fetchCachedCategories(for section: String) -> [CategoryEntity] {
        defer {
            fetchCachedCategoriesForExpectation.fulfill()
        }
        fetchCachedCategoriesForCallsCount += 1
        fetchCachedCategoriesForCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchCachedCategoriesForReceivedSection = section
        return fetchCachedCategoriesForClosure.map { $0(section) } ?? fetchCachedCategoriesForReturnValue
    }

    func fetchCachedStream(for section: String, categoryId: String) -> [Stream] {
        defer {
            fetchCachedStreamForCategoryIdExpectation.fulfill()
        }
        fetchCachedStreamForCategoryIdCallsCount += 1
        fetchCachedStreamForCategoryIdCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchCachedStreamForCategoryIdReceivedArguments = (section: section, categoryId: categoryId)
        return fetchCachedStreamForCategoryIdClosure.map { $0(section, categoryId) } ?? fetchCachedStreamForCategoryIdReturnValue
    }

    func fetchFilteredCategories(for section: String) -> [CategoryEntity] {
        defer {
            fetchFilteredCategoriesForExpectation.fulfill()
        }
        fetchFilteredCategoriesForCallsCount += 1
        fetchFilteredCategoriesForCalledOnQueueLabel = String(cString: __dispatch_queue_get_label(nil))
        fetchFilteredCategoriesForReceivedSection = section
        return fetchFilteredCategoriesForClosure.map { $0(section) } ?? fetchFilteredCategoriesForReturnValue
    }
}
