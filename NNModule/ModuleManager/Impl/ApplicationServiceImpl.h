//
//  ModuleApplicationServiceImpl.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import "ModuleApplicationService.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationServiceImpl : NSObject <ModuleApplicationService>

@property (nonatomic, strong) UIWindow *window;

@end

NS_ASSUME_NONNULL_END
