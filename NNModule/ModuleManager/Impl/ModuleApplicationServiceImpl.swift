//
//  ModuleApplicationServiceImpl.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/18.
//

import Foundation

class ModuleApplicationServiceImpl: NSObject, ModuleApplicationService {
    
    var window: UIWindow?
  
    required override init() { super.init() }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool { true }
}
