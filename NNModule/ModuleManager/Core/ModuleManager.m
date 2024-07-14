//
//  ModuleManager.m
//  ModuleManagment
//
//  Created by NeroXie on 2023/10/27.
//

#import "ModuleManager.h"
#import "Module.h"
#import "ApplicationServiceImpl.h"
#import "URLRouter+NNModule.h"
#import "TabServiceImpl.h"
#import "LaunchTaskServiceImpl.h"
#import "NotificationServiceImpl.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ModuleManager

+ (ModuleManager *)sharedInstance {
    static ModuleManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [Module registerService:@protocol(ModuleApplicationService) usedClass:ApplicationServiceImpl.class];
        [Module registerService:@protocol(ModuleRouteService) usedClass:URLRouter.class];
        [Module registerService:@protocol(ModuleTabService) usedClass:TabServiceImpl.class];
        [Module registerService:@protocol(ModuleLaunchTaskService) usedClass:LaunchTaskServiceImpl.class];
        [Module registerService:@protocol(ModuleNotificationService) usedClass:NotificationServiceImpl.class];
        
        [self _loadAllMethodsFromClass:ModuleRegisterService.class];
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    // load application service early
    id<ModuleApplicationService> applicationImpl = Module.applicationService;
    if ([applicationImpl respondsToSelector:@selector(applicationWillAwake)]) {
        [applicationImpl applicationWillAwake];
    }
    
    // wake up all modules.
    [self _loadAllMethodsFromClass:ModuleAwake.class];
    // execute launch task
    id<ModuleLaunchTaskService> launchTaskImpl = Module.launchTaskService;
    if ([launchTaskImpl respondsToSelector:@selector(executeTasks)]) {
        [Module.launchTaskService executeTasks];
    }
    
    if ([applicationImpl respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
        return [applicationImpl application:application willFinishLaunchingWithOptions:launchOptions];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [self _loadWindowIfNeed];
    
    BOOL result = YES;
    id<ModuleApplicationService> applicationImpl = Module.applicationService;
    if ([applicationImpl respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        result = [applicationImpl application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
#if DEBUG
    NSLog(@"application did finish launching");
    [Module serviceInfoPrettyPrinted];
#endif
    return result;
}

- (void)_loadWindowIfNeed {
    if (UIApplication.sharedApplication.keyWindow) return;
    
    id<ModuleApplicationService> applicationImpl = Module.applicationService;
    id<UIApplicationDelegate> applicationDelegate = UIApplication.sharedApplication.delegate;
    UIWindow *window = nil;
    if ([applicationImpl respondsToSelector:@selector(window)]) {
        UIWindow *win = applicationDelegate.window;
        if (win) window = win;
    } else if ([applicationDelegate respondsToSelector:@selector(window)]) {
        UIWindow *win = applicationDelegate.window;
        if (win) window = win;
    } else {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.backgroundColor = UIColor.whiteColor;
    }
    
    if ([applicationImpl respondsToSelector:@selector(window)]) applicationImpl.window = window;
    if ([applicationDelegate respondsToSelector:@selector(window)]) applicationDelegate.window = window;
    
    [window makeKeyWindow];
}

- (void)_loadAllMethodsFromClass:(Class)aClass {
    Class metaClass = object_getClass(aClass);
    unsigned int count;
    Method *methods = class_copyMethodList(metaClass, &count);
    for (int i = 0; i < count; i++) {
        Method class_Method = methods[i];
        const char *methodName = sel_getName(method_getName(class_Method));
        // Class method of load and initialize invoked by OC runtime
        if (strcmp(methodName, "load") == 0 || strcmp(methodName, "initialize") == 0) continue;
        ((void(*)(id,Method))method_invoke)(metaClass, class_Method);
    }
}

@end
