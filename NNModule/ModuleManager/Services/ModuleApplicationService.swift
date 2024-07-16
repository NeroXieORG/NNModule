//
//  ModuleAppService.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/18.
//

import Foundation

/// Application Service
/// This service is used to implement the functions which in `UIApplicationDelegate`.
@objc public protocol ModuleApplicationService: ModuleFunctionalService, UIApplicationDelegate {
    
    /// Invoke before calling class methods of Module.Awake and after calling class methods of Module.RegisterService.
    @objc optional func applicationWillAwake()
    
    /// Reload the main view controller
    @objc optional func reloadMainViewController()
}
