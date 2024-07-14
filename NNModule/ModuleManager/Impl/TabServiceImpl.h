//
//  ModuleTabServiceImpl.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import "ModuleTabService.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabServiceImpl : NSObject <ModuleTabService>

@property (nonatomic, strong, nullable) UITabBarController *tabBarController;

@end

NS_ASSUME_NONNULL_END
