//
//  NNServiceManager.m
//  ModuleManagment
//
//  Created by NeroXie on 2023/10/27.
//

#import "ServiceManager.h"
#import "ServiceBridgeProxy.h"
#import <objc/runtime.h>

@interface ServiceManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class<ModuleFunctionalService>> *serviceTypeMap;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<ModuleBasicService>> *implInstanceMap;

@property (nonatomic, strong) NSMutableArray<ServiceBridgeProxy *> *proxyList;

#ifdef DEBUG
@property (nonatomic, strong) NSMutableArray *implClassList;
#endif

@end

@implementation ServiceManager

- (instancetype)init {
    if (self = [super init]) {
        _serviceTypeMap = NSMutableDictionary.new;
        _implInstanceMap = NSMutableDictionary.new;
        _proxyList = NSMutableArray.new;
#ifdef DEBUG
        _implClassList = NSMutableArray.new;
#endif
    }
    
    return self;
}

+ (ServiceManager *)sharedInstance {
    static ServiceManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    
    return _sharedInstance;
}

- (void)registerServiceWithIdentifier:(NSString *)identifier implClass:(Class)implClass {
    if (!identifier.length || !implClass) return;
    if (![implClass conformsToProtocol:@protocol(ModuleFunctionalService)]) {
        NSAssert1(NO, @"The class of %@ needs to follow `ModuleFunctionalService`", implClass);
        return;
    }
    
    Class<ModuleFunctionalService> newImplClass = implClass;
    Class<ModuleFunctionalService> oldImplClass = self.serviceTypeMap[identifier];
    if (!oldImplClass) {
        self.serviceTypeMap[identifier] = newImplClass;
        return;
    }
    
    NSInteger oldImplPriority = 0;
    if ([oldImplClass respondsToSelector:@selector(implPriority)]) {
        oldImplPriority = [oldImplClass implPriority];
    }
    
    NSInteger newImplPriority = 0;
    if ([newImplClass respondsToSelector:@selector(implPriority)]) {
        newImplPriority = [newImplClass implPriority];
    }
    
    if (oldImplPriority < newImplPriority) {
        self.serviceTypeMap[identifier] = newImplClass;
    }
}

- (void)removeServiceWithIdentifier:(NSString *)identifier {
    Class<ModuleFunctionalService> implClass = self.serviceTypeMap[identifier];
    if (!implClass) return;
    
    // remove service from map
    [self.serviceTypeMap removeObjectForKey:identifier];
    // check implClass whether to confirm other services
    BOOL confirmOtherService = [self.serviceTypeMap.allValues containsObject:implClass];
    // check implClass whether to confirm ModuleRegisteredService
    BOOL keepaliveRegiteredImpl = NO;
    if ([implClass conformsToProtocol:@protocol(ModuleRegisteredService)]) {
        if ([implClass respondsToSelector:@selector(keepaliveRegiteredImpl)]) {
            keepaliveRegiteredImpl = [(Class<ModuleRegisteredService>)implClass keepaliveRegiteredImpl];
        }
    }
    
    if (!keepaliveRegiteredImpl && !confirmOtherService) {
        [self.implInstanceMap removeObjectForKey:@([implClass hash])];
    }
}

- (id<ModuleFunctionalService>)serviceImplOfIdentifier:(NSString *)identifier {
    __block ServiceBridgeProxy *selectedProxy = nil;
    __block NSUInteger selectedIndex = -1;
    [self.proxyList enumerateObjectsUsingBlock:^(ServiceBridgeProxy *proxy, NSUInteger idx, BOOL *stop) {
        if ([proxy.identifier isEqualToString:identifier]) {
            selectedProxy = proxy;
            selectedIndex = idx;
            *stop = YES;
        }
    }];
    
    if (!selectedProxy) return [self serviceNativeImplOfIdentifier:identifier];
    
    id<ModuleFunctionalService> nativeImpl = [self serviceNativeImplOfIdentifier:identifier];
    if (!nativeImpl) {
        [self.proxyList removeObjectAtIndex:selectedIndex];
        return nil;
    }
    
    selectedProxy.nativeImpl = nativeImpl;
    if ([selectedProxy conformsToProtocol:@protocol(ModuleFunctionalService)]) {
        return (id<ModuleFunctionalService>)selectedProxy;
    }
    
    return nil;
}

- (id<ModuleFunctionalService>)serviceNativeImplOfIdentifier:(NSString *)identifier {
    Class implClass = self.serviceTypeMap[identifier];
    if (!implClass) return nil;
    
    NSNumber *implKey = @([implClass hash]);
    id<ModuleBasicService> impl = self.implInstanceMap[implKey];
    if (impl) return (id<ModuleFunctionalService>)impl;
    
#ifdef DEBUG
    NSString *className = NSStringFromClass(implClass);
    if ([self.implClassList containsObject:className]) {
        NSMutableString *string = [@"Found loop when creating service impl: " mutableCopy];
        for (NSString *name in self.implClassList) [string appendFormat:@"%@ ->", name];
        [string appendString:className];
        NSAssert(NO, string);
        return nil;
    }
    [self.implClassList addObject:className];
#endif
    
    impl = [implClass respondsToSelector:@selector(implInstance)] ? [implClass implInstance] : [[implClass alloc] init];
#ifdef DEBUG
    [self.implClassList removeAllObjects];
#endif
    self.implInstanceMap[implKey] = impl;
    
    return (id<ModuleFunctionalService>)impl;
}

- (id<ModuleRegisteredService>)registerImplOfClass:(Class)implClass {
    if (!implClass || ![self _checkRegisteredServiceOfClass:implClass]) return nil;
    
    NSNumber *implKey = @([implClass hash]);
    BOOL keepalive = NO;
    if ([implClass respondsToSelector:@selector(keepaliveRegiteredImpl)]) {
        keepalive = [implClass keepaliveRegiteredImpl];
    }

    id<ModuleBasicService> impl = self.implInstanceMap[implKey];
    if (keepalive && impl) return (id<ModuleRegisteredService>)impl;
    
    impl = [implClass respondsToSelector:@selector(implInstance)] ? [implClass implInstance] : [[implClass alloc] init];
        
    if (keepalive) self.implInstanceMap[implKey] = impl;
    return (id<ModuleRegisteredService>)impl;
}

- (void)bridgeMethod:(SEL)method isClassMethod:(BOOL)isClassMethod identifier:(NSString *)identifier usedClass:(Class)aClass {
    if (!self.serviceTypeMap[identifier] || ![self _checkRegisteredServiceOfClass:aClass]) return;
    
    __block ServiceBridgeProxy *proxy = nil;
    [self.proxyList enumerateObjectsUsingBlock:^(ServiceBridgeProxy *obj, NSUInteger idx, BOOL *stop) {
        if ([identifier isEqualToString:obj.identifier]) {
            proxy = obj;
            *stop = YES;
        }
    }];
    
    if (!proxy) {
        proxy = [ServiceBridgeProxy proxyWithIdentifier:identifier];
        [self.proxyList addObject:proxy];
    }
    
    [proxy setBridgeClass:aClass forMethod:method isClassMethod:isClassMethod];
}

- (void)serviceInfoPrettyPrinted {
#ifdef DEBUG
    NSMutableArray *proxyListJson = @[].mutableCopy;
    for (ServiceBridgeProxy *proxy in self.proxyList) {
        NSData *data = [proxy.description dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (json) [proxyListJson addObject:json];
    }
    
    
    NSMutableDictionary *serviceTypeMapJson = @{}.mutableCopy;
    [self.serviceTypeMap enumerateKeysAndObjectsUsingBlock:^(NSString *key, Class<ModuleFunctionalService>obj, BOOL * _Nonnull stop) {
        [serviceTypeMapJson setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
    }];
    
    NSMutableDictionary *implInstanceMapJson = @{}.mutableCopy;
    [self.implInstanceMap enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id<ModuleBasicService> obj, BOOL * _Nonnull stop) {
        NSString *stringValue = [NSString stringWithFormat:@"%@", obj];
        NSString *stringKey = [NSString stringWithFormat:@"%@", key];
        [implInstanceMapJson setValue:stringValue forKey:stringKey];
    }];
    
    
    NSDictionary *map = @{
        @"bridgeProxyList": proxyListJson,
        @"serviceTypeMap": serviceTypeMapJson,
        @"implInstanceMap": implInstanceMapJson,
    };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"service info = %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
#endif
}

#pragma mark - Private Method

- (BOOL)_checkBasicServiceOfClass:(Class)implClass {
//    if (![implClass respondsToSelector:@selector(implInstance)]) {
//        NSAssert1(NO, @"The class of %@ needs to implement the `implInstance` method", implClass);
//        return NO;
//    }
//    
    return YES;
}

- (BOOL)_checkFunctionalServiceOfClass:(Class)implClass {
    if (![implClass conformsToProtocol:@protocol(ModuleFunctionalService)]) {
        NSAssert1(NO, @"The class of %@ needs to follow `ModuleFunctionalService`", implClass);
        return NO;
    }
    
    return YES;
}

- (BOOL)_checkRegisteredServiceOfClass:(Class)implClass {
    if (![implClass conformsToProtocol:@protocol(ModuleRegisteredService)]) {
        NSAssert1(NO, @"The class of %@ needs to follow `ModuleRegisteredService`", implClass);
        return NO;
    }
    
    return [self _checkBasicServiceOfClass:implClass];
}

@end
