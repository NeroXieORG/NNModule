//
//  Module+swift.swift
//  NNModule-swift
//
//  Created by NeroXie on 2024/7/13.
//

import Foundation

public extension Module {
    
    /// Register services
    /// - Parameters:
    ///   - serviceType: The type of serivce
    ///   - implClass: The class that implements the service.
    static func register<Service>(service serviceType: Service.Type, used implClass: AnyClass) {
        guard implClass is Service else {
            assertionFailure("\(implClass) must conforms to service \(serviceType)")
            return
        }
        
        let identifier = String(reflecting: serviceType).replacingOccurrences(of: "__C.", with: "")
        ServiceManager.shared.registerService(with: identifier, implClass: implClass)
    }
    
    /// Get the instance of the service.
    /// If the service is customized, the instance type is `ServiceImplProxy`, otherwise it returns native instance.
    /// - Parameter serviceType: The type of serivce.
    /// - Returns: The instance of serivce.
    static func serviceImpl<Service>(of serviceType: Service.Type) -> Service {
        let identifier = String(reflecting: serviceType).replacingOccurrences(of: "__C.", with: "")
        return ServiceManager.shared.serviceImpl(of: identifier) as! Service
    }
    
    /// Get the native instance of the service.
    /// Since the instance is lazy loaded, so pay attention to whether there is a service mutual reference in the constructor.
    /// - Parameter serviceType: The type of serivce.
    /// - Returns: The instance of serivce.
    static func serviceNativeImpl<Service>(of serviceType: Service.Type) -> Service {
        let identifier = String(reflecting: serviceType).replacingOccurrences(of: "__C.", with: "")
        return ServiceManager.shared.serviceNativeImpl(of: identifier) as! Service
    }
    
    /// Remove service
    /// - Parameter serviceType: The type of serivce
    static func removeService<Service>(of serviceType: Service.Type) {
        let identifier = String(reflecting: serviceType).replacingOccurrences(of: "__C.", with: "")
        ServiceManager.shared.removeService(with: identifier)
    }
    
    /// Bridge a instance method in the service.
    /// - Parameters:
    ///   - method: The instance method in the service.
    ///   - serviceType: The type of serivce.
    ///   - aClass: The class that implements the bridged instance method.
    static func bridge<Service>(method: Selector, of serviceType: Service.Type, used aClass: AnyClass) {
        let identifier = String(reflecting: serviceType).replacingOccurrences(of: "__C.", with: "")
        ServiceManager.shared.bridgeMethod(method, isClassMethod: false, identifier: identifier, usedClass: aClass)
    }
    
    /// Bridge a class method in the service.
    /// - Parameters:
    ///   - classMethod: The class method in the service.
    ///   - serviceType: The type of serivce.
    ///   - aClass: The class that implements the bridged class method.
    static func bridge<Service>(classMethod: Selector, of serviceType: Service.Type, used aClass: AnyClass) {
        let identifier = String(reflecting: serviceType).replacingOccurrences(of: "__C.", with: "")
        ServiceManager.shared.bridgeMethod(classMethod, isClassMethod: true, identifier: identifier, usedClass: aClass)
    }
}

