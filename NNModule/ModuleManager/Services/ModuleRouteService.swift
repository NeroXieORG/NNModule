//
//  ModuleRouteService.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/18.
//

import Foundation

@objc public protocol RegisterRouteModuleService: ModuleRegisteredService, URLRouteModuleType {}

/// Services used to provide routing
@objc public protocol ModuleRouteService: ModuleFunctionalService, URLRouterType, URLRouterTypeAttach {
    
    func addRouteModuleRegister(_ register: RegisterRouteModuleService.Type)
}

@objc extension URLRouter: ModuleRouteService {
    
    public static var implInstance: ModuleBasicService { URLRouter.default }
    
    public func addRouteModuleRegister(_ register: RegisterRouteModuleService.Type) {
        guard let routeModule = Module.registerImpl(of: register) as? URLRouteModuleType else { return }
        
        addRouteModule(routeModule)
    }
}



