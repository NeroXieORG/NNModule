//
//  NotificationServiceImpl.m
//  NNModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import "NotificationServiceImpl.h"

@implementation NotificationServiceImpl

- (NotificationObserver *)addObserverForName:(NSNotificationName)name usingBlock:(void (^)(NSNotification * _Nonnull))block {
    return [self addObserverForName:name isSticky:false usingBlock:block];
}

- (NotificationObserver *)addObserverForName:(NSNotificationName)name isSticky:(BOOL)isSticky usingBlock:(void (^)(NSNotification * _Nonnull))block {
    return [self addObserverForName:name isSticky:isSticky object:nil usingBlock:block];
}

- (NotificationObserver *)addObserverForName:(NSNotificationName)name isSticky:(BOOL)isSticky object:(id)object usingBlock:(void (^)(NSNotification * _Nonnull))block {
    return [self addObserverForName:name isSticky:isSticky object:object queue:nil usingBlock:block];
}

- (NotificationObserver *)addObserverForName:(NSNotificationName)name isSticky:(BOOL)isSticky object:(id)object queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification * _Nonnull))block {
    return [NSNotificationCenter.defaultCenter addObserverForName:name isSticky:isSticky object:object queue:queue using:block];
}

- (void)postNotification:(NSNotificationName _Nonnull)name {
    [self postNotification:name isSticky:false];
}

- (void)postNotification:(NSNotificationName _Nonnull)name isSticky:(BOOL)isSticky {
    [self postNotification:name isSticky:isSticky object:nil];
}

- (void)postNotification:(NSNotificationName _Nonnull)name isSticky:(BOOL)isSticky object:(id _Nullable)object {
    [self postNotification:name isSticky:isSticky object:object userInfo:nil];
}

- (void)postNotification:(NSNotificationName)name isSticky:(BOOL)isSticky object:(id)object userInfo:(NSDictionary *)userInfo {
    [NSNotificationCenter.defaultCenter postWithName:name isSticky:isSticky object:object userInfo:userInfo];
}

- (void)removeStickyNotification:(NSNotificationName _Nonnull)name {
    [NSNotificationCenter.defaultCenter removeStickyNotificationFor:name];
}

@end


