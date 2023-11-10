//
//  URLRouteInterceptor.swift
//  NNModule-swift
//
//  Created by NeroXie on 2022/11/8.
//

import Foundation

/// The result of intercepting a route.
@objc public enum URLRouteInterceptionResult: Int {
    
    // interception failed, can continue
    case next = 0
    
    // interception success, can not continue
    case reject = 1
}

/// A route interception action.
@objc public protocol URLRouteInterceptionAction: NSObjectProtocol {
    
    /// Specified routes.
    ///
    /// It will match all routes if the value is nil or an empty array.
    var specifiedRoutes: [URLRouteName]? { get }
    
    @objc(interceptRouteForRouteUrl:)
    /// Intercepts route.
    /// - Parameter routeUrl: A data used to describe a route
    /// - Returns: The result of intercepting the route
    func interceptRoute(for routeUrl: RouteURL) -> URLRouteInterceptionResult
}

@objcMembers public class URLRouteInterceptor: NSObject {
    
    private var actionMatchedRoutesMap: [ObjectIdentifier: [String]] = [:]
    
    public private(set) var actions: [URLRouteInterceptionAction] = []
    
    private weak var routeParser: URLRouteParserType? = nil
    
    @objc(initWithRouteParser:)
    public init(with routeParser: URLRouteParserType = URLRouteParser()) {
        self.routeParser = routeParser
    }
    
    @objc(insertAction:atIndex:)
    /// Inserts a new action at the specified position.
    /// - Parameters:
    ///   - action: The new action to insert into the action.
    ///   - i: The position at which to insert the new element.
    public func insert(_ action: URLRouteInterceptionAction, at i: Int) {
        if actions.contains(where: { $0 === action }) { return }
        
        configMatchedRoutes(with: action)
        actions.insert(action, at: i)
    }
    
    @objc(appendAction:)
    /// Adds a new action at the end of the actions.
    /// - Parameter action: The action to append to the actions.
    public func append(_ action: URLRouteInterceptionAction) {
        if actions.contains(where: { $0 === action }) { return }
        
        configMatchedRoutes(with: action)
        actions.append(action)
    }
    
    /// Removes the specified action from actions.
    /// - Parameter action: The action to remove from actions.
    public func remove(_ action: URLRouteInterceptionAction) {
        actions.removeAll { $0 === action }
        actionMatchedRoutesMap.removeValue(forKey: ObjectIdentifier(action))
    }
    
    /// The result of intercepting a route.
    /// - Parameter routeUrl: A data used to describe a route.
    /// - Returns: The result of interception.
    public func interceptSuccessfully(for routeUrl: RouteURL) -> Bool {
        let matchedActions = actions.filter { action in
            let routes = actionMatchedRoutesMap[ObjectIdentifier(action)] ?? []
            if routes.isEmpty { return true }
            
            return routes.contains { $0 == routeUrl.fullPath || $0 == routeUrl.combinedRoute }
        }
            
        for action in matchedActions {
            switch action.interceptRoute(for: routeUrl) {
            case .reject: return true
            case .next: continue
            }
        }
        
        return false
    }
    
    private func configMatchedRoutes(with action: URLRouteInterceptionAction) {
        var matchedRoutes: [URLRouteName] = []
        for route in action.specifiedRoutes ?? [] {
            guard let routeUrl = routeParser?.routeUrl(from: route) else {
                continue
            }
            
            matchedRoutes.append(routeUrl.fullPath)
        }
        
        actionMatchedRoutesMap[ObjectIdentifier(action)] = matchedRoutes
    }
}

extension URLRouteInterceptor {
    
    @objc(URLRouteInterceptorAction)
    /// Default interception action.
    @objcMembers public class Action: NSObject, URLRouteInterceptionAction {
        
        public private(set) var specifiedRoutes: [URLRouteName]?
        
        public typealias Handler = (_ routeUrl: RouteURL) -> URLRouteInterceptionResult
        
        private var interceptionHandler: Handler
        
        public init(specifiedRoutes: [URLRouteName]? = nil, handler: @escaping Handler) {
            self.specifiedRoutes = specifiedRoutes
            self.interceptionHandler = handler
        }
        
        public convenience init(specifiedRoute: URLRouteName, handler: @escaping Handler) {
            self.init(specifiedRoutes: [specifiedRoute], handler: handler)
        }
        
        public func interceptRoute(for routeUrl: RouteURL) -> URLRouteInterceptionResult {
            interceptionHandler(routeUrl)
        }
    }
}
