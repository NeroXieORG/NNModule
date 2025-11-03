//
//  LoginModuleImpl.swift
//  LoginModule
//
//  Created by NeroXie on 2024/7/13.
//

import Foundation
import ModuleServices
import NNModule_swift

extension Module.RegisterService {
    
    @objc static func loginModuleRegisterService() {
        Module.register(service: LoginService.self, used: LoginManager.self)
    }
}

extension Module.Awake {
    
    @objc static func loginModuleAwake() {
        Module.routeService.addRegister(LoginModuleImpl.self)
    }
}

fileprivate class LoginModuleImpl: NSObject, RegisterRouteModuleService {
    
    var delayedLoadingRoutes: [URLRouteName] { ["login"] }
    
    required override init() { super.init() }
    
    func configRoutes(with router: URLRouterType) {
        router.registerRoute("login/register") { routeUrl, navigator in
            navigator.push(RegisterViewController())
            return true
        }
    }
}
