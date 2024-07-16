//
//  URLRouterType.swift
//  ApplicationModule
//
//  Created by NeroXie on 2022/11/20.
//

import Foundation

public typealias HandleRouteFactory = (_ routeUrl: RouteURL, _ navigator: NavigatorType) -> Bool

// MARK: - URLRouterType

@objc public protocol URLRouterType: NSObjectProtocol {
    
    /// A route paraser converts URL or String to RouteURL.
    var routeParser: URLRouteParserType { get }
    
    /// A navigator push or present view controller.
    var navigator: NavigatorType { get }
    
    //    @available(*, deprecated, message: "This method has been deprecated!")
    //    /// Registers a route with a route handler.
    //    /// - Parameters:
    //    ///   - route: The route name
    //    ///   - handleRouteFactory: The route handler to call when the route is matched.
    //    func delayedRegisterRoute(_ route: URLRouteName, handleRouteFactory: @escaping HandleRouteFactory)
    
    /// Registers a route with a route handler.
    /// - Parameters:
    ///   - route: The route name.
    ///   - handleRouteFactory: The route handler to call when the route is matched.
    func registerRoute(_ route: URLRouteName, handleRouteFactory: @escaping HandleRouteFactory)
    
    /// Remove a route.
    /// - Parameter route: The route name.
    func removeRoute(_ route: URLRouteName)
    
    /// Removes all routes.
    func removeAllRoutes()
    
    @discardableResult
    /// Executes a route open handler.
    /// - Parameters:
    ///   - route: The route name.
    ///   - parameters: The route parameters.
    /// - Returns: Bool
    func openRoute(_ route: URLRouteName, parameters: [String: Any]) -> Bool
}

// MARK: - URLRouteModuleType

@objc public protocol URLRouteModuleType: NSObjectProtocol {
    
    /// The routes require delayed loading.
    ///
    /// When this value is empty, `configRoutes(with router:)` will be executed immediately.
    /// Otherwise, `configRoutes(with router:)` will be executed only when navigating with `openRoute(_ route:, parameters:)` to a route contained in `delayedLoadingRoutes`."
    ///
    /// Note:
    /// `delayedLoadingRoutes` should preferably return combined routes.
    @objc optional var delayedLoadingRoutes: [URLRouteName] { get }
    
    @objc(configRoutesWithRouter:)
    /// Configure routes for the current module.
    /// - Parameter router: A router
    func configRoutes(with router: URLRouterType)
}

// MARK: - URLRouterTypeAttach

@objc public protocol URLRouterTypeAttach: NSObjectProtocol {
    
    /// A redirector for redirecting routes.
    var routeRedirector: URLRouteRedirector { get }
    
    /// A route interceptor that decides whether to execute the route.
    var routeInterceptor: URLRouteInterceptor { get }
    
    /// Adds a route module.
    /// - Parameter routeModule: The instance conforms `URLRouteModuleType`.
    func addRouteModule(_ routeModule: URLRouteModuleType)
}

// MARK: - Extension

extension URLRouterType {
    
    @discardableResult
    public func openRoute(_ route: URLRouteName, parameters: [String: Any] = [:]) -> Bool {
        openRoute(route, parameters: parameters)
    }
}
