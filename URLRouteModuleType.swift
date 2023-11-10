//
//  URLRouteRegisterType.swift
//  NNModule-swift
//
//  Created by NeroXie on 2023/11/9.
//

import Foundation

@objc public protocol URLRouteModuleType: NSObjectProtocol {
    
    /// The routes require delayed loading.
    /// 
    /// When this value is empty, `configRoutes(with router:)` will be executed immediately.
    /// Otherwise, `configRoutes(with router:)` will be executed only when navigating with `openRoute(_ route:, parameters:)` to a route contained in `delayedLoadingRoutes`."
    ///
    /// Note:
    /// `delayedLoadingRoutes` should preferably return combined routes.
    @objc optional var delayedLoadingRoutes: [URLRouteName] { get }
    
    /// Configure routes for the current module.
    /// - Parameter router: A router
    func configRoutes(with router: URLRouterType)
}
