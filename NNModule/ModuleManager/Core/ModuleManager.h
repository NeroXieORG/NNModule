//
//  ModuleManager.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModuleManager : NSObject

@property (nonatomic, strong, readonly, class) ModuleManager *sharedInstance NS_SWIFT_NAME(shared);

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:( nullable NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions;

@end

NS_ASSUME_NONNULL_END
