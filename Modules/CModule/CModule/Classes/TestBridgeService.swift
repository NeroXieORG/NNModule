//
//  TestBridgeService.swift
//  ModuleServices
//
//  Created by NeroXie on 2023/5/29.
//

import Foundation
import NNModule_swift

@objc protocol ATestBridgeService: ModuleFunctionalService {
    
    func a_testMethod()
    
    static func a_1_testMethod()
}

@objc protocol BTestBridgeService: ModuleFunctionalService {
    
    func b_testMethod()
    
    static func b_1_testMethod()
}

final class ATestBridgeServiceImpl: NSObject, ATestBridgeService {
    
    func a_testMethod() {
        debugPrint("ATestBridgeServiceImpl a_testMethod")
    }
    
    static func a_1_testMethod() {
        debugPrint("ATestBridgeServiceImpl a_1_testMethod")
    }
}

final class BTestBridgeServiceImpl: NSObject, BTestBridgeService {
    
    func b_testMethod() {
        debugPrint("BTestBridgeServiceImpl b_testMethod")
    }
    
    static func b_1_testMethod() {
        debugPrint("BTestBridgeServiceImpl b_1_testMethod")
    }
}

class ATestBridgeServiceBridge: NSObject, ModuleRegisteredService {
    
    required override init() {
        super.init()
    }
    
    @objc func a_testMethod() {
        Module.serviceNativeImpl(of: ATestBridgeService.self).a_testMethod()
        debugPrint("==== ATestBridgeServiceBridge a_testMethod ====")
       
    }
    
    @objc static func a_1_testMethod() {
        type(of: Module.serviceNativeImpl(of: ATestBridgeService.self)).a_1_testMethod()
        debugPrint("==== ATestBridgeServiceBridge a_1_testMethod ====")
    }
    
    static var keepaliveRegiteredImpl: Bool { true }
}

class BTestBridgeServiceBridge: NSObject, ModuleRegisteredService {
    
    required override init() {
        super.init()
    }
    
    @objc func b_testMethod() {
        Module.serviceNativeImpl(of: BTestBridgeService.self).b_testMethod()
        debugPrint("==== BTestBridgeServiceBridge b_testMethod ====")
       
    }
    
    @objc static func b_1_testMethod() {
        type(of: Module.serviceNativeImpl(of: BTestBridgeService.self)).b_1_testMethod()
        debugPrint("==== BTestBridgeServiceBridge b_1_testMethod ====")
    }
    
    static var keepaliveRegiteredImpl: Bool { true }
}
