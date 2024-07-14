//
//  Module.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/1.
//

#import <Foundation/Foundation.h>
#import "ModuleBasicService.h"
#import "ModuleTabService.h"
#import "ModuleApplicationService.h"
#import "ModuleRouteService.h"
#import "ModuleLaunchTaskService.h"
#import "ModuleNotificationService.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Module.RegisterService)
/// 注册 Service 切面类，通过添加分类与类方法实现 Service 注入, 声明的类方法不需要参数，方法名没有限制
/// 
/// 示例代码:
///
/// @implementation ModuleRegisterService (ConfigModule)
///
/// + (void)configModuleRegisterService {
///     [Module registerServiceOfProtocol:xxx usedImplClass:xxxx];
/// }
///
/// @end
@interface ModuleRegisterService: NSObject

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_SWIFT_NAME(Module.Awake)
/// Service 初始化切面类，通过添加分类与类方法实现 Service 注入, 声明的类方法不需要参数，方法名没有限制
///
/// 实例代码:
///
/// @implementation ModuleAwake (ConfigModule)
///
/// + (void)configModuleAwake {
///     [Module.routeService registerRoute:@"xxx" handleRouteFactory:^BOOL(RouteURL *routeUrl, id<NavigatorType> navigator) {
///         // 处理路由
///     }];
/// }
///
/// @end
@interface ModuleAwake: NSObject

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end

/// 组件管理快速类
@interface Module : NSObject

@property (nonatomic, strong, class, readonly) id<ModuleApplicationService> applicationService;

@property (nonatomic, strong, class, readonly) id<ModuleTabService> tabService;

@property (nonatomic, strong, class, readonly) id<ModuleRouteService> routeService;

@property (nonatomic, strong, class, readonly) id<ModuleLaunchTaskService> launchTaskService;

@property (nonatomic, strong, class, readonly) id<ModuleNotificationService> notificationService;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

/// 注册功能型 Service
/// - Parameters:
///   - service: Service 类型
///   - implClass: Service 对应的实现类
+ (void)registerService:(Protocol *)service usedClass:(Class)implClass;

/// 删除功能型 Service
/// - Parameter service: 功能型 Service
+ (void)removeService:(Protocol *)service;

/// 获取功能型 Service 对应的实现类实例，如果 Service 经过桥接则返回对应的 Proxy 类
/// - Parameter service: 功能型 Service
+ (nullable id)implOfService:(Protocol *)service;

/// 获取功能型 Service 对应的实现类真正实例
/// - Parameter service: 功能型 Service
+ (nullable id)nativeImplOfService:(Protocol *)service;

/// 获取注册型 Service 实例
/// - Parameter implClass: 类名
+ (nullable id)registerImplOfClass:(Class)implClass NS_SWIFT_NAME(registerImpl(of:));

/// 桥接功能型 Service 中的某一个对象方法
/// Note：桥接类需要实现同名函数才能完成桥接，通过该功能可以实现 Service 的 AOP 切面
///
/// - Parameters:
///   - method: 实例方法名
///   - service: 功能型 Service 名
///   - aClass: 桥接类
+ (void)bridgeMethod:(SEL)method ofService:(Protocol *)service usedClass:(Class<ModuleRegisteredService>)aClass;

/// 桥接功能型 Service 中的某一个类方法
/// Note：桥接类需要实现同名函数才能完成桥接，通过该功能可以实现 Service 的 AOP 切面
///
/// - Parameters:
///   - method: 类方法名
///   - service: 功能型 Service 名
///   - aClass: 桥接类
+ (void)bridgeClassMethod:(SEL)method ofService:(Protocol *)service usedClass:(Class<ModuleRegisteredService>)aClass;

+ (void)serviceInfoPrettyPrinted;

@end

NS_ASSUME_NONNULL_END
