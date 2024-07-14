//
//  ModuleNoficationService.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import "ModuleBasicService.h"
#import <NNModule_Notification/NNModule_Notification-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ModuleNotificationService <ModuleFunctionalService>

- (NotificationObserver * _Nonnull)addObserverForName:(NSNotificationName _Nullable)name usingBlock:(void (^ _Nonnull)(NSNotification * _Nonnull))block SWIFT_WARN_UNUSED_RESULT;

- (NotificationObserver * _Nonnull)addObserverForName:(NSNotificationName _Nullable)name isSticky:(BOOL)isSticky usingBlock:(void (^ _Nonnull)(NSNotification * _Nonnull))block SWIFT_WARN_UNUSED_RESULT;

- (NotificationObserver * _Nonnull)addObserverForName:(NSNotificationName _Nullable)name isSticky:(BOOL)isSticky object:(id _Nullable)object usingBlock:(void (^ _Nonnull)(NSNotification * _Nonnull))block SWIFT_WARN_UNUSED_RESULT;

- (NotificationObserver * _Nonnull)addObserverForName:(NSNotificationName _Nullable)name isSticky:(BOOL)isSticky object:(id _Nullable)object queue:(NSOperationQueue * _Nullable)queue usingBlock:(void (^ _Nonnull)(NSNotification * _Nonnull))block SWIFT_WARN_UNUSED_RESULT;

- (void)postNotification:(NSNotificationName _Nonnull)name;

- (void)postNotification:(NSNotificationName _Nonnull)name isSticky:(BOOL)isSticky;

- (void)postNotification:(NSNotificationName _Nonnull)name isSticky:(BOOL)isSticky object:(id _Nullable)object;

- (void)postNotification:(NSNotificationName _Nonnull)name isSticky:(BOOL)isSticky object:(id _Nullable)object userInfo:(NSDictionary * _Nullable)userInfo;

- (void)removeStickyNotification:(NSNotificationName _Nonnull)name;

@end

NS_ASSUME_NONNULL_END
