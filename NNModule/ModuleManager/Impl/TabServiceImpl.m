//
//  TabServiceImpl.m
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import "TabServiceImpl.h"
#import "Module.h"

@interface TabBarItemMeta ()

@property (nonatomic, weak) id<RegisterTabService> registerImpl;

@end

@implementation TabBarItemMeta

@end

@interface TabServiceImpl()

@property (nonatomic, strong) NSMutableSet *registerClassList;

@property (nonatomic, strong) NSArray<TabBarItemMeta *> *tabBarItems;

@end

@implementation TabServiceImpl

- (instancetype)init {
    if (self = [super init]) {
        self.registerClassList = NSMutableSet.new;
        self.tabBarItems = @[];
    }
    
    return self;
}

- (void)tabBarControllerDidLoad {
    if (!self.tabBarController) return;
    
    NSMutableArray *items = self.tabBarItems.mutableCopy;
    for (Class<RegisterTabService> registerClass in self.registerClassList) {
        id<RegisterTabService> registerImpl = [Module registerImplOfClass:registerClass];
        if (!registerImpl) continue;
        
        if ([registerImpl respondsToSelector:@selector(setupTabBarController:)]) {
            [registerImpl setupTabBarController:self.tabBarController];
        }
        
        if ([registerImpl respondsToSelector:@selector(registerTabBarItems)]) {
            for (TabBarItemMeta *meta in [registerImpl registerTabBarItems]) {
                meta.registerImpl = registerImpl;
                [items addObject:meta];
            }
        }
    }

    self.tabBarItems = [items sortedArrayUsingComparator:^NSComparisonResult(TabBarItemMeta *obj1, TabBarItemMeta *obj2) {
        return [@(obj1.tabIndex) compare:@(obj2.tabIndex)];
    }];
}

- (void)needReloadTabBarController {
    self.tabBarController = nil;
    self.tabBarItems = @[];
}

- (void)addRegister:(Class<RegisterTabService>)registerClass {
    if (!registerClass || ![registerClass conformsToProtocol:@protocol(RegisterTabService)]) return;
    
    [self.registerClassList addObject:registerClass];
}

- (id<RegisterTabService>)implInTabBarController:(UITabBarController *)tabBarController viewController:(UIViewController *)viewController {
    if (!self.tabBarController || self.tabBarController != tabBarController) return nil;
    
    NSUInteger index = [tabBarController.childViewControllers indexOfObject:viewController];
    return self.tabBarItems[index].registerImpl;
}

@end
