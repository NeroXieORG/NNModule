//
//  ModuleManager.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/18.
//

import Foundation
import UIKit

@objcMembers public final class ModuleManager: NSObject {
    
    @objc(sharedInstance)
    public static let shared = ModuleManager()
    
    private var registerServices = [Method]()
    
    private var awakes = [Method]()
    
    private override init() {
        super.init()
        
        // register services
        Module.register(service: ModuleRouteService.self, used: URLRouter.self)
        Module.register(service: ModuleTabService.self, used: ModuleTabServiceImpl.self)
        Module.register(service: ModuleLaunchTaskService.self, used: ModuleLaunchTaskServiceImpl.self)
        Module.register(service: ModuleNotificationService.self, used: ModuleNotificationServiceImpl.self)
        Module.register(service: ModuleApplicationService.self, used: ModuleApplicationServiceImpl.self)
        
        // register more services
        loadAllMethods(from: Module.RegisterService.self)
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadWindowIfNeed()
        // load application service early
        let applicationImpl = Module.applicationService
        applicationImpl.applicationWillAwake?()
        // wake up all modules to register
        loadAllMethods(from: Module.Awake.self)
        // execute launch task
        Module.launchTaskService.executeTasks()
        
        let result = Module.applicationService.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true
#if DEBUG
        print("application did finish launching")
        ModuleServiceCenter.shared.serviceInfoPrettyPrinted()
#endif
        return result
    }
    
    private func loadWindowIfNeed() {
        guard UIApplication.shared.keyWindow == nil else { return }
        
        // forcibly load the window
        let sel = NSSelectorFromString("setWindow:")
        var window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        if let win = Module.applicationService.window as? UIWindow { window = win }
        Module.applicationService.perform(sel, with: window)
        if let delegate = UIApplication.shared.delegate, delegate.responds(to: sel) {
            delegate.perform(sel, with: window)
        }
        
        window.makeKeyAndVisible()
    }
    
    private func loadAllMethods(from aClass: AnyClass) {
        guard let metaClass: AnyClass = object_getClass(aClass) else { return }
        
        var count: UInt32 = 0
        guard let methodList = class_copyMethodList(metaClass, &count) else { return }
        
        let handle = dlopen(nil, RTLD_LAZY)
        let methodInvoke = dlsym(handle, "method_invoke")
        
        for i in 0..<Int(count) {
            let method = methodList[i]
            unsafeBitCast(methodInvoke, to:(@convention(c)(Any, Method)->Void).self)(metaClass, method)
        }
        
        dlclose(handle)
        free(methodList)
    }
}

