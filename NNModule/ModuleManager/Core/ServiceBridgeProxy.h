//
//  ServiceBridgeProxy.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Service 方法桥接
@interface ServiceBridgeProxy : NSProxy

/// Service 标识
@property (nonatomic, copy, readonly) NSString *identifier;

/// Service 的原始实现类实例
@property (nonatomic, weak) id nativeImpl;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)proxyWithIdentifier:(NSString *)identifier;

- (void)setBridgeClass:(Class)bridgeClass forMethod:(SEL)method isClassMethod:(BOOL)isClassMethod;

@end

NS_ASSUME_NONNULL_END
