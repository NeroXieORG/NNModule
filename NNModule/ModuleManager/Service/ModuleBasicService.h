//
//  ModuleBasicService.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 基础 Service，所有的 Service 均基于该服务
@protocol ModuleBasicService <NSObject>

@required

- (instancetype)init;

@optional
/// 指定 Service 实现类的实例，默认为 [[类 alloc]init].
+ (id <ModuleBasicService>)implInstance;

@end

/// 功能类型 Service
@protocol ModuleFunctionalService <ModuleBasicService>

@optional

/// impl 优先级，默认为0。
+ (NSInteger)implPriority;

@end

/// 注册类型 Service
@protocol ModuleRegisteredService <ModuleBasicService>

@optional

/// 是否保活impl，默认为NO。
/// 当返回YES时，通过[Module registerImplOfClass:aClass]获取到的是一个重用的impl实例，否则获取的是一个新创建的impl实例。
+ (BOOL)keepaliveRegiteredImpl;

@end

NS_ASSUME_NONNULL_END
