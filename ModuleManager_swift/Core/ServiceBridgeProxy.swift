////
////  ServiceBridgeProxy.swift
////  NNModule-swift
////
////  Created by NeroXie on 2024/2/20.
////
//
//import Foundation
//
//typealias MethodMirror = [String: AnyClass]
//
//typealias MethodMirrorMap = [String: MethodMirror]
//
//class ServiceBridgeProxy: NSObject {
//    
//    let identifier: String
//    
//    weak var nativeImpl: AnyObject? = nil {
//        
//        didSet { type(of: self).nativeImplClass = nativeImpl != nil ? type(of: nativeImpl!) : nil }
//    }
//    
//    private class var nativeImplClass: AnyClass? {
//        
//        get {
//            return objc_getAssociatedObject(self, &nativeImplClassKey) as? AnyClass
//        }
//        
//        set { objc_setAssociatedObject(self, &nativeImplClassKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//    }
//    
//    //    private var bridgeImplMap: [String: BridgeImplTarget] = [:]
//    
//    class func ttt_methodMirrorMap() {
//        print(self)
//    }
////    
////    private func setMethodMirrorMap(_ methodMirrorMap: MethodMirrorMap) {
////        objc_setAssociatedObject(self, &methodMirrorMapKey, methodMirrorMap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
////    }
////    
//    private class var methodMirrorMap: MethodMirrorMap {
//        
//        set { objc_setAssociatedObject(self, &methodMirrorMapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//        
//        get {
//            if let map = objc_getAssociatedObject(self, &methodMirrorMapKey) as? MethodMirrorMap {
//                return map
//            }
//            
//            let map: MethodMirrorMap = ["classMethod": [:], "instanceMethod": [:]]
//            objc_setAssociatedObject(self, &methodMirrorMapKey, map, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            return map
//        }
//    }
//    
//    @objc required init(identifier: String) {
//        self.identifier = identifier
//    }
//    
//    static func proxy(with identifier: String) -> ServiceBridgeProxy? {
//        let bridgeName = "\(identifier)_BridgeProxy"
//        let superClass: AnyClass? = NSClassFromString("NNModule_swift.ServiceBridgeProxy")
//        guard let bridgeClass = objc_allocateClassPair(superClass!, bridgeName, 0) else {
//            return nil
//        }
//        
//        print(bridgeClass)
//        objc_registerClassPair(bridgeClass)
//        
////        let selector = #selector(ServiceBridgeProxy.init(identifier:))
////        let methodIMP = class_getMethodImplementation(ServiceBridgeProxy.self, selector)
////        typealias MethodIMP = @convention(c)(AnyObject, Selector, String) -> ServiceBridgeProxy
////        let InitFunction = unsafeBitCast(methodIMP, to: MethodIMP.self)
////        return InitFunction(bridgeClass, selector, identifier)
//        
//        
//        return (bridgeClass as! ServiceBridgeProxy.Type).init(identifier: identifier)
//    }
//    
//    func bridgeClass(_ aClass: AnyClass, for method: Selector, isClassMethod: Bool = false) {
//        print(self)
//        print(self.classForCoder)
//        let methodName = NSStringFromSelector(method)
//        let key = isClassMethod ? "classMethod" : "instanceMethod"
//        if let _ = type(of: self).methodMirrorMap[key]?[methodName] {
//            assertionFailure("Method \(methodName) of service \(identifier) have been hooked already!")
//        } else {
//            type(of: self).methodMirrorMap[key]?[methodName] = aClass
//        }
//    }
//    
//    override func isProxy() -> Bool { true }
//    
//    override func forwardingTarget(for aSelector: Selector!) -> Any? {
//        let methodName = NSStringFromSelector(aSelector)
//        //        if let bridgeImpl = bridgeImplMap[methodName]?.value {
//        //            return bridgeImpl
//        //        }
//        //
//        if let bridgeClass = type(of: self).methodMirrorMap["instanceMethod"]?[methodName],
//           let bridgeImpl = Module.registerImpl(of: bridgeClass),
//           bridgeImpl.responds(to: aSelector) {
//            //            bridgeImplMap[methodName] = BridgeImplTarget(bridgeImpl)
//            return bridgeImpl
//        }
//        
//        return nativeImpl
//    }
//    
//    override class func forwardingTarget(for aSelector: Selector!) -> Any? {
//        let methodName = NSStringFromSelector(aSelector)
//        if let bridgeClass = methodMirrorMap["classMethod"]?[methodName], bridgeClass.responds(to: aSelector) {
//            return bridgeClass
//        }
//        
//        return nativeImplClass
//    }
//    
//    override func conforms(to aProtocol: Protocol) -> Bool {
//        nativeImpl?.conforms(to: aProtocol) ?? false
//    }
//    
//    override func isKind(of aClass: AnyClass) -> Bool {
//        nativeImpl?.isKind(of: aClass) ?? false
//    }
//    
//    
//    
////        override var description: String {
////            var bridgeMethodMap:[String:[String: String]] = ["classMethod": [:], "instanceMethod": [:]]
////            type(of: self).methodMirrorMap.forEach { key, methodMirror in
////                methodMirror.forEach { methodName, bridgeClass in
////                    bridgeMethodMap[key]?[methodName] = NSStringFromClass(bridgeClass)
////                }
////            }
////    
////            let map: [String: Any] = ["identifier": identifier, "bridgeMethodMap": bridgeMethodMap]
////            do {
////                let mapData = try JSONSerialization.data(withJSONObject: map, options: .prettyPrinted)
////                return String(data: mapData, encoding: .utf8) ?? ""
////            } catch _ {
////                return ""
////            }
////        }
//}
//
//private var nativeImplClassKey: Void?
//
//private var methodMirrorMapKey: Void?
//
////fileprivate func setNativeImplClass(_ )
