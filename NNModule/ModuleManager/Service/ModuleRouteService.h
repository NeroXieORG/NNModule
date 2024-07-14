//
//  ModuleRouteService.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import "ModuleBasicService.h"
#import <NNModule_URLRouter/NNModule_URLRouter-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RegisterRouteModuleService <ModuleRegisteredService, URLRouteModuleType>

@end

/// 路由服务
@protocol ModuleRouteService <ModuleFunctionalService, URLRouterType, URLRouterTypeAttach>

- (void)registerRouteModule:(Class<RegisterRouteModuleService>)routeModuleClass;

@end


NS_ASSUME_NONNULL_END
