//
//  ModuleApplicationService.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModuleBasicService.h"

NS_ASSUME_NONNULL_BEGIN

/// Basic service
/// All services must be based on this service.
@protocol ModuleApplicationService <ModuleFunctionalService, UIApplicationDelegate>

@required

- (void)applicationWillAwake;

- (void)reloadMainViewController;

@end

NS_ASSUME_NONNULL_END

