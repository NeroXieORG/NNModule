//
//  RouteURL.swift
//  NNModule-swift
//
//  Created by NeroXie on 2023/10/31.
//

import Foundation

public typealias URLRouteName = String

/// RouteURL is a data structure used to describe a routing entry.
/// Generally speaking, the URL data will be filled in RouteURL.
@objcMembers public class RouteURL: NSObject {
    
    public let scheme: String

    public let host: String
    
    public let path: String
    
    public private(set) var parameters: [String: Any]
    
    public var isWebLink: Bool { scheme.isWebScheme }
    
    /// The combined route that uses both scheme and host.
    ///
    /// For example:
    /// Route name: app://host/path
    /// Combined route: app://host
    public var combinedRoute: String { "\(scheme)://\(host)" }
    
    public var fullPath: String { "\(scheme)://\(host)\(path)" }
    
    public init(scheme: String, host: String, path: String, parameters: [String: Any]) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.parameters = parameters
    }
    
    public func resetParameters(_ parameters: [String: Any]) {
        self.parameters = parameters
    }
    
    public func mergingParameters(_ parameters: [String: Any]) {
        self.parameters = self.parameters.merging(parameters) { _, second in second }
    }
    
    public override var description: String { "URL full path: \(fullPath)\nURL parameters: \(parameters)" }
}

fileprivate extension String {
    
    var isWebScheme: Bool { lowercased() == "https" || lowercased() == "http" }
}
