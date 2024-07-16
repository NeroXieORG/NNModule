//
//  ServiceBridgeProxy.h
//  NNModule-swift
//
//  Created by NeroXie on 2023/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceBridgeProxy : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, weak) id nativeImpl;

+ (instancetype)proxyWithIdentifier:(NSString *)identifier;

- (void)setBridgeClass:(Class)bridgeClass forMethod:(SEL)method isClassMethod:(BOOL)isClassMethod;

- (NSString *)proxyInfo;

@end

NS_ASSUME_NONNULL_END
