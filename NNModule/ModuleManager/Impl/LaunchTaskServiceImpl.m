//
//  LaunchTaskServiceImpl.m
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import "LaunchTaskServiceImpl.h"
#import "Module.h"

@interface LaunchTaskServiceImpl ()

@property (nonatomic, strong) NSMutableSet *registerClassList;

@end

@implementation LaunchTaskServiceImpl

- (instancetype)init {
    if (self = [super init]) {
        self.registerClassList = NSMutableSet.new;
    }
    
    return self;
}

#pragma mark - ModuleLaunchTaskService

- (void)addRegister:(Class<RegisterLaunchTaskService>)registerClass {
    if (!registerClass || ![registerClass conformsToProtocol:@protocol(RegisterLaunchTaskService)]) return;
    
    [self.registerClassList addObject:registerClass];
}

- (void)executeTasks {
    NSMutableArray *tasks = NSMutableArray.new;
    for (Class<RegisterLaunchTaskService> registerClass in self.registerClassList) {
        id<RegisterLaunchTaskService> taskImpl = [Module registerImplOfClass:registerClass];
        if (taskImpl) [tasks addObject:taskImpl];
    }
    
    NSArray *sortedTasks = [tasks sortedArrayUsingComparator:^NSComparisonResult(id<RegisterLaunchTaskService> obj1, id<RegisterLaunchTaskService> obj2) {
        LaunchTaskPriority priority1 = [obj1 respondsToSelector:@selector(taskPriority)] ? [obj1 taskPriority] : LaunchTaskPriorityNormal;
        LaunchTaskPriority priority2 = [obj2 respondsToSelector:@selector(taskPriority)] ? [obj2 taskPriority] : LaunchTaskPriorityNormal;
        
        return [@(priority1) compare:@(priority2)];
    }];
    
    for (id<RegisterLaunchTaskService> taskImpl in sortedTasks) {
        LaunchTaskRunMode runMode = LaunchTaskRunModeGlobalAsync;
        if ([taskImpl respondsToSelector:@selector(taskRunMode)]) {
            runMode = [taskImpl taskRunMode];
        }
        
        if (runMode == LaunchTaskRunModeMainSync) {
            [taskImpl executeTask];
        } else if (runMode == LaunchTaskRunModeMainAsync) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [taskImpl executeTask];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [taskImpl executeTask];
            });
        }
    }
}

@end
