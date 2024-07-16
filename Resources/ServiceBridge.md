# Service Bridge

## 简介

ModuleManager 在 1.0.7 版本新增了对 Service 接口提供的方法新增了桥接功能，实现了类似 AOP 的效果，可以在不重新全量实现类的情况下，单独定制某个方法。

## 使用

**接口声明**

```swift
/// Bridge a instance method in the service.
///
/// Note:
/// 1. The service need add @objc tag
/// 2. The Method of bridge class need add @objc tag
///
/// - Parameters:
///   - method: The instance method in the service.
///   - serviceProtocol: The type of service.
///   - aClass: The class that implements the bridged instance method.
static func bridge(method: Selector, of serviceProtocol: Protocol, used aClass: ModuleRegisteredService.Type)

/// Bridge a class method in the service.
///
/// Note:
/// 1. The service need add @objc tag
/// 2. The Method of bridge class need add @objc tag
///
/// - Parameters:
///   - classMethod: The class method in the service.
///   - serviceProtocol: The type of service.
///   - aClass: The class that implements the bridged class method.
static func bridge(classMethod: Selector, of serviceProtocol: Protocol, used aClass: ModuleRegisteredService.Type)
```

**使用**

```swift
// Service 添加 @objc 支持桥接
@objc protocol ATestBridgeService: ModuleFunctionalService {
    
    func a_testMethod()
    
    static func a_1_testMethod()
}

// 定义桥接类
class ATestBridgeServiceBridge: NSObject, ModuleRegisteredService {
    
    required override init() { super.init() }
    
    @objc func a_testMethod() {
        Module.serviceNativeImpl(of: ATestBridgeService.self).a_testMethod()
        debugPrint("==== ATestBridgeServiceBridge a_testMethod ====")
    }
    
    static var keepaliveRegiteredImpl: Bool { true }
}

// 调用桥接
Module.bridge(
    method: NSSelectorFromString("a_testMethod"),
    of: ATestBridgeService.self,
    used: ATestBridgeServiceBridge.self
)
```


