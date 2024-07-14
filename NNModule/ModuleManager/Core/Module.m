//
//  Module.m
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/1.
//

#import "Module.h"
#import "ServiceManager.h"

@implementation ModuleRegisterService

@end

@implementation ModuleAwake

@end

@implementation Module

+ (id<ModuleApplicationService>)applicationService {
    return [self implOfService:@protocol(ModuleApplicationService)];
}

+ (id<ModuleRouteService>)routeService {
    return [self implOfService:@protocol(ModuleRouteService)];
}

+ (id<ModuleTabService>)tabService {
    return [self implOfService:@protocol(ModuleTabService)];
}

+ (id<ModuleLaunchTaskService>)launchTaskService {
    return [self implOfService:@protocol(ModuleLaunchTaskService)];
}

+ (id<ModuleNotificationService>)notificationService {
    return [self implOfService:@protocol(ModuleNotificationService)];
}

+ (void)registerService:(Protocol *)service usedClass:(Class)implClass {
    NSString *identifier = NSStringFromProtocol(service);
    [ServiceManager.sharedInstance registerServiceWithIdentifier:identifier implClass:implClass];
}

+ (void)removeService:(Protocol *)service {
    NSString *identifier = NSStringFromProtocol(service);
    [ServiceManager.sharedInstance removeServiceWithIdentifier:identifier];
}

+ (id)implOfService:(Protocol *)service {
    NSString *identifier = NSStringFromProtocol(service);
    return [ServiceManager.sharedInstance serviceImplOfIdentifier:identifier];
}

+ (id)nativeImplOfService:(Protocol *)service {
    NSString *identifier = NSStringFromProtocol(service);
    return [ServiceManager.sharedInstance serviceNativeImplOfIdentifier:identifier];
}

+ (id)registerImplOfClass:(Class)implClass {
    return [ServiceManager.sharedInstance registerImplOfClass:implClass];
}

+ (void)bridgeMethod:(SEL)method ofService:(Protocol *)service usedClass:(Class)aClass {
    NSString *identifier = NSStringFromProtocol(service);
    [ServiceManager.sharedInstance bridgeMethod:method isClassMethod:NO identifier:identifier usedClass:aClass];
}

+ (void)bridgeClassMethod:(SEL)method ofService:(Protocol *)service usedClass:(Class)aClass {
    NSString *identifier = NSStringFromProtocol(service);
    [ServiceManager.sharedInstance bridgeMethod:method isClassMethod:YES identifier:identifier usedClass:aClass];
}

+ (void)serviceInfoPrettyPrinted {
    [ServiceManager.sharedInstance serviceInfoPrettyPrinted];
}

@end
