//
//  ModuleServiceManager.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/18.
//

import Foundation

/// The manager of service's map
final class ModuleServiceCenter {
    
    static let shared = ModuleServiceCenter()
    
    private var proxyList: [ServiceBridgeProxy] = []
    
    private(set) var serviceTypeMap: [ServiceIdentifier: ModuleFunctionalService.Type] = [:]
    
    private var implInstanceMap: [ObjectIdentifier: ModuleBasicService] = [:]
    
#if DEBUG
    private var implClassList: [String] = []
#endif
    
    private init() {}
    
    func registerService(of identifier: ServiceIdentifier, used implClass: AnyClass) {
        guard let newImplClass = implClass as? ModuleFunctionalService.Type else {
            assertionFailure("\(identifier.value) must conforms to service `ModuleFunctionalService`")
            return
        }
        
        guard let oldImplClass = serviceTypeMap[identifier] else {
            serviceTypeMap[identifier] = newImplClass
            return
        }
        
        if (oldImplClass.implPriority ?? 0) < (newImplClass.implPriority ?? 0) {
            serviceTypeMap[identifier] = newImplClass
        }
    }
    
    func serviceImpl(of identifier: ServiceIdentifier) -> ModuleFunctionalService? {
        guard let proxy = proxyList.first(where: { $0.identifier == identifier.value }) else {
            return serviceNativeImpl(of: identifier)
        }
        
        guard let nativeImpl = serviceNativeImpl(of: identifier) else {
            proxyList.removeAll { $0.identifier == identifier.value }
            return nil
        }
        
        proxy.nativeImpl = nativeImpl
        return proxy as? ModuleFunctionalService
    }
    
    func serviceNativeImpl(of identifier: ServiceIdentifier) -> ModuleFunctionalService? {
        guard let implClass = serviceTypeMap[identifier] else {
            assertionFailure("The impl class of \(identifier.value) is nil, please register it first.")
            return nil
        }
        
        let implKey = ObjectIdentifier(implClass)
        if let impl = implInstanceMap[implKey] as? ModuleFunctionalService { return impl }
        
#if DEBUG
        let className = "\(implClass)"
        guard !implClassList.contains(className) else {
            var string = "Found loop when creating service impl: "
            implClassList.forEach { string += "\($0) -> " }
            string += className
            assertionFailure(string)
            
            return nil
        }
        
        implClassList.append(className)
#endif
        let newImpl = implClass.implInstance ?? implClass.init()
#if DEBUG
        implClassList.removeAll()
#endif
        implInstanceMap[implKey] = newImpl
        
        return newImpl as? ModuleFunctionalService
    }
    
    func registerImpl(of implClass: AnyClass) -> ModuleRegisteredService? {
        if let newImplClass = implClass as? ModuleRegisteredService.Type {
            let keepalive = newImplClass.keepaliveRegiteredImpl ?? false
            return impl(of: newImplClass, needKeepalive: keepalive) as? ModuleRegisteredService
        }
        
        return nil
    }
    
    func removeService(of identifier: ServiceIdentifier) {
        guard let implClass = serviceTypeMap.removeValue(forKey: identifier) else { return }
        
        // as registered service
        if (implClass as? ModuleRegisteredService.Type)?.keepaliveRegiteredImpl ?? false { return }
        if let _  = serviceTypeMap.first(where: { _, value in value == implClass }) { return }
        implInstanceMap.removeValue(forKey: ObjectIdentifier(implClass))
    }
    
    func bridge(method: Selector, isClassMethod: Bool, of identifier: ServiceIdentifier, used aClass: ModuleRegisteredService.Type) {
        guard aClass.keepaliveRegiteredImpl ?? false else {
            assertionFailure("The value of `keepaliveRegiteredImpl` in \(aClass) must be `true`.")
            return
        }
        
        guard let _ = serviceTypeMap[identifier] else {
            assertionFailure("The impl class of \(identifier.value) is nil, please register it first.")
            return
        }
        
        if let proxy = proxyList.first(where: { $0.identifier == identifier.value }) {
            proxy.setBridgeClass(aClass, forMethod: method, isClassMethod: isClassMethod)
            return
        }
        
        let proxy = ServiceBridgeProxy(identifier: identifier.value)
        proxy.setBridgeClass(aClass, forMethod: method, isClassMethod: isClassMethod)
        proxyList.append(proxy)
    }
    
    func serviceInfoPrettyPrinted() {
#if DEBUG
        let newProxyList = proxyList.map {
            guard let data = $0.proxyInfo().data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
                return [String: Any]()
            }
            
            return json
        }
        
        let map: [ String: Any] = [
            "bridgeProxyList": newProxyList,
            "serviceTypeMap": Dictionary(uniqueKeysWithValues: serviceTypeMap.map { ("\($0)", "\($1)") }) ,
            "implInstanceMap": Dictionary(uniqueKeysWithValues: implInstanceMap.map { ("\($0)", "\($1)") })
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: map, options: .prettyPrinted),
           let jsonString = String(data: data, encoding: .utf8) {
            print("Service info = \(jsonString)")
        }
#endif
    }
    
    private func impl(of implClass: AnyClass, needKeepalive keepalive: Bool) -> AnyObject? {
        guard let newImplClass = implClass as? ModuleBasicService.Type else {
            return nil
        }
        
        let key = ObjectIdentifier(newImplClass)
        if keepalive, let impl = implInstanceMap[key] {
            return impl
        }
        
        let newImpl = newImplClass.implInstance ?? newImplClass.init()
        // save impl of this class if it is possible
        if keepalive { implInstanceMap[key] = newImpl }
        
        return newImpl
    }
}
