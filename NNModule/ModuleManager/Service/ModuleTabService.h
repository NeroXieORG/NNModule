//
//  ModuleTabService.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModuleBasicService.h"

NS_ASSUME_NONNULL_BEGIN

@class TabBarItemMeta;

@protocol RegisterTabService <ModuleRegisteredService, UITabBarControllerDelegate>

@required

/// 注册 tabBar items
- (NSArray<TabBarItemMeta *> *)registerTabBarItems;

@optional

/// setup tabBarController
/// - Parameter tabBarController: The controller of tab service.
- (void)setupTabBarController:(UITabBarController *)tabBarController;

@end

@protocol ModuleTabService <ModuleFunctionalService>

@required

@property (nonatomic, strong, nullable) UITabBarController *tabBarController;

@property (nonatomic, strong, readonly) NSArray<TabBarItemMeta *> *tabBarItems;

- (void)tabBarControllerDidLoad;

- (void)needReloadTabBarController;

- (void)addRegister:(Class<RegisterTabService>)registerClass;

- (nullable id<RegisterTabService>)implInTabBarController:(UITabBarController *)tabBarController viewController:(UIViewController *)viewController NS_SWIFT_NAME(impl(in:viewcontroller:));

@end

@interface TabBarItemMeta : NSObject

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, assign) NSUInteger tabIndex;

@end

NS_ASSUME_NONNULL_END
