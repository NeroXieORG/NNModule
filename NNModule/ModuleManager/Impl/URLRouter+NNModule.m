//
//  URLRouter+NNModule.m
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import "URLRouter+NNModule.h"
#import "Module.h"

@implementation URLRouter (NNModule)

- (void)registerRouteModule:(Class<RegisterRouteModuleService>)routeModuleClass {
    if (![routeModuleClass conformsToProtocol:@protocol(RegisterRouteModuleService)]) return;
    
    id<RegisterRouteModuleService> impl = [Module registerImplOfClass:routeModuleClass];
    [self addRouteModule:impl];
}

+ (id<ModuleBasicService>)implInstance {
    return URLRouter.defaultRouter;
}

@end
