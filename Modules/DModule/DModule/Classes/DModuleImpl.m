//
//  DModuleImpl.m
//  DModule
//
//  Created by NeroXie on 2024/7/15.
//

#import "DModuleImpl.h"
#import <NNModule_swift/NNModule_swift-Swift.h>
#import "DModuleMainViewController.h"

@implementation ModuleAwake (DModule)

+ (void)DModuleAwake {
    [Module.routeService addRegister:DModuleImpl.class];
}

@end

@interface DModuleImpl () <RegisterRouteModuleService>

@end

@implementation DModuleImpl

- (NSArray<NSString *> *)delayedLoadingRoutes {
    return @[@"dmodule"];
}

- (void)configRoutesWithRouter:(id<URLRouterType>)router {
    [router registerRoute:@"dmodule/main" handleRouteFactory:^BOOL(RouteURL *routeUrl, id<NavigatorType> navigator) {
        [navigator pushViewController:DModuleMainViewController.new animated:YES];
        return YES;
    }];
}

@end
