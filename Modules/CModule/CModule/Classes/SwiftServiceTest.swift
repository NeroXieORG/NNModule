//
//  SwiftImpl.swift
//  CModule
//
//  Created by NeroXie on 2024/7/15.
//

import Foundation
import NNModule_swift

extension Module.RegisterService {
    
    @objc static func SwiftServiceTestRegisterService() {
        Module.register(service: SwiftServiceInSwift.self, used: SwiftServiceInSwiftImpl.self)
        Module.register(service: OCServiceInSwift.self, used: OCServiceInSwiftImpl.self)
    }
}

extension Module.Awake {
    
    @objc static func SwiftServiceTestAwake() {
        Module.serviceImpl(of: SwiftServiceInSwift.self).print()
        Module.serviceImpl(of: OCServiceInSwift.self).print()
    }
}

@objc public protocol SwiftServiceInSwift: ModuleFunctionalService {
    
    func print()
}

@objc public protocol SwiftServiceInOC: ModuleFunctionalService {
    
    func print()
}

class SwiftServiceInSwiftImpl: NSObject, SwiftServiceInSwift {
    
    required override init() { super.init() }
    
    func print() {
        debugPrint("SwiftServiceInSwift")
    }
}

class OCServiceInSwiftImpl: NSObject, OCServiceInSwift {
    
    required override init() { super.init() }
    
    func print() {
        debugPrint("OCServiceInSwift")
    }
}
