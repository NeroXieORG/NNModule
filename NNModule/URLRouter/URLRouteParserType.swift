//
//  URLRouteParserType.swift
//  NNModule-swift
//
//  Created by NeroXie on 2023/10/31.
//

import Foundation

/// A protocol used to convert URL or String to RouteURL.
@objc public protocol URLRouteParserType: NSObjectProtocol {
    
    /// Default URL scheme.
    /// 
    /// If the url string does not contain a scheme, the default scheme will be used.
    var defaultScheme: String { get }
    
//    @objc(urlFromRoute:)
//    /// Returns the URL through the route.
//    /// - Parameter route: Specify a route
//    /// - Returns: URL
//    func url(from route: URLRouteName) -> URL?
    
    @objc(routeUrlFromRoute:params:)
    /// Returns the RouteURL through the route and custom parameters.
    /// - Parameters:
    ///   - route: Specify a route
    ///   - params: Those custom parameters that cannot be put in the URL.
    /// - Returns: RouteURL
    func routeUrl(from route: URLRouteName, params: [String: Any]) -> RouteURL?
}

public extension URLRouteParserType {
    
    func routeUrl(from route: URLRouteName, params: [String: Any] = [:]) -> RouteURL? {
        routeUrl(from: route, params: params)
    }
}
