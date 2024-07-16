//
//  Router.swift
//  Router
//
//  Created by NeroXie on 2019/1/7.
//

import Foundation

@objcMembers public class URLRouter: NSObject, URLRouterType, URLRouterTypeAttach {
 
    // The default route to handle the URL has http or https.
    public static var webLink: URLRouteName { "://weblink" }
    
    public private(set) var routeParser: URLRouteParserType = URLRouteParser()
    
    public private(set) var navigator: NavigatorType = Navigator()
    
    public private(set) var routeRedirector: URLRouteRedirector
    
    public private(set) var routeInterceptor: URLRouteInterceptor
        
    private var routeModulesMap = [String: URLRouteModuleType]()
    
    private var handleRouteFactories = [String: HandleRouteFactory]()
        
    @objc(defaultRouter)
    public static var `default` = URLRouter()
    
    // MARK: - Init Method
    
    public required override init() {
        routeRedirector = URLRouteRedirector(with: routeParser)
        routeInterceptor = URLRouteInterceptor(with: routeParser)
        
        super.init()
    }
    
    public required init(routeParser: URLRouteParserType = URLRouteParser(), navigator: NavigatorType = Navigator()) {
        self.routeParser = routeParser
        self.navigator = navigator
        routeRedirector = URLRouteRedirector(with: routeParser)
        routeInterceptor = URLRouteInterceptor(with: routeParser)
        
        super.init()
    }
    
    // MARK: - URLRouterType
    
    public func registerRoute(_ route: URLRouteName, handleRouteFactory: @escaping HandleRouteFactory) {
        guard let routeUrl = routeParser.routeUrl(from: route) else {
            URLRouterLog("route for (\(route)) is invalid")
            return
        }
        
        let key = routeUrl.fullPath
        if handleRouteFactories[key] != nil {
            URLRouterLog("route for (\(route)) already exist")
            return
        }
        
        handleRouteFactories[key] = handleRouteFactory
    }
        
    public func removeRoute(_ route: URLRouteName) {
        guard let routeUrl = routeParser.routeUrl(from: route) else {
            URLRouterLog("route for (\(route)) is invalid")
            return
        }
        
        let key = routeUrl.fullPath
        handleRouteFactories.removeValue(forKey: key)
        routeModulesMap.removeValue(forKey: key)
    }
    
    public func removeAllRoutes() {
        handleRouteFactories = [:]
        routeModulesMap = [:]
    }
    
    @discardableResult
    public func openRoute(_ route: URLRouteName, parameters: [String: Any]) -> Bool {
        guard let routeUrl = routeParser.routeUrl(from: route, params: parameters) else {
            URLRouterLog("route for (\(route)) is invalid")
            return false
        }
        
        // Load delayed routes
        loadDelayedRoutes(from: routeUrl)
        
        // Check if is a redirected route
        if let redirectData = routeRedirector.routeRedirectData(from: routeUrl) {
            return openRoute(redirectData.route, parameters: redirectData.params)
        }
        
        // Check if is web link
        if routeUrl.isWebLink {
            if let handler = findRouteHandler(with: routeUrl) {
                return invokeRouteHandler(handler, routeUrl: routeUrl)
            }
            
            if let webLinkRouteUrl = routeParser.routeUrl(from: URLRouter.webLink),
               let webLinkHandler = findRouteHandler(with: webLinkRouteUrl) {
                return invokeRouteHandler(webLinkHandler, routeUrl: routeUrl)
            }
            
            URLRouterLog("route for (\(route)) is web link, please register handler for web links")
            return false
        }
        
        if let handler = findRouteHandler(with: routeUrl) {
            return invokeRouteHandler(handler, routeUrl: routeUrl)
        }
        
        URLRouterLog("route for (\(route)) is not exist")
        return false
    }
    
    // MARK: - URLRouterTypeAttach
    
    public func addRouteModule(_ routeModule: URLRouteModuleType) {
        var delayedLoadingRoutes = Set<String>()
        for route in routeModule.delayedLoadingRoutes ?? [] {
            guard let routeUrl = routeParser.routeUrl(from: route) else {
                URLRouterLog("Route for (\(route)) from (\(routeModule)) is invalid.")
                continue
            }
            
            delayedLoadingRoutes.insert(routeUrl.combinedRoute)
        }
        
        if (delayedLoadingRoutes.isEmpty) {
            routeModule.configRoutes(with: self)
            return
        }
        
        for route in delayedLoadingRoutes {
            if let oldRouteModule = routeModulesMap[route] {
                URLRouterLog("Delayed loading route (\(route)) from \(routeModule) has been registered in \(oldRouteModule).")
                continue
            }
            
            routeModulesMap[route] = routeModule;
        }
    }

    // MARK: - Private Method
    
    private func loadDelayedRoutes(from routeUrl: RouteURL) {
        var tmp = routeModulesMap[routeUrl.combinedRoute]
        if (tmp == nil && routeUrl.isWebLink) { tmp = routeModulesMap[URLRouter.webLink] }

        guard let routeModule = tmp else { return }
        
        routeModule.configRoutes(with: self)
        routeModulesMap = routeModulesMap.filter { (_, value) in value !== routeModule }
    }
    
    private func findRouteHandler(with routeUrl: RouteURL) -> HandleRouteFactory? {
        if let handler = handleRouteFactories[routeUrl.fullPath]  { 
            return handler
        }
        
        if !routeUrl.path.isEmpty,
           let combinedRouteUrl = routeParser.routeUrl(from: routeUrl.combinedRoute),
           let combinedHandler = handleRouteFactories[combinedRouteUrl.fullPath] {
            return combinedHandler
        }
        
        return nil
    }
    
    private func invokeRouteHandler(_ handler: HandleRouteFactory, routeUrl: RouteURL) -> Bool {
        if routeInterceptor.interceptSuccessfully(for: routeUrl) { return false }
        
        return handler(routeUrl, navigator)
    }
}

//fileprivate func RouteModuleKey(_ routeUrl: RouteURL) -> String { routeUrl.combinedRoute }
//
//fileprivate func RouteHandlerKey(_ routeUrl: RouteURL) -> String { routeUrl.fullPath }

public func URLRouterLog<T>(_ message: T) {
#if DEBUG
    print("⚠️ URLRouter Error: \(message)")
#endif
}

