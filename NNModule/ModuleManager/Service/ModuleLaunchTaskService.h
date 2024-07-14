//
//  ModuleLaunchTaskService.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import "ModuleBasicService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LaunchTaskRunMode) {
    LaunchTaskRunModeMainSync = 0,
    LaunchTaskRunModeMainAsync = 1,
    LaunchTaskRunModeGlobalAsync = 2,
};

typedef NS_ENUM(NSInteger, LaunchTaskPriority) {
    LaunchTaskPriorityLow = 100,
    LaunchTaskPriorityNormal = 200,
    LaunchTaskPriorityHigh = 300,
};

@protocol RegisterLaunchTaskService <ModuleRegisteredService>

@required

- (void)executeTask;

@optional

- (LaunchTaskRunMode)taskRunMode;

- (LaunchTaskPriority)taskPriority;

@end

@protocol ModuleLaunchTaskService <ModuleFunctionalService>

@required

- (void)addRegister:(Class<RegisterLaunchTaskService>)registerClass;

- (void)executeTasks;

@optional

@property (nonatomic, assign) BOOL debugMode;

@end

NS_ASSUME_NONNULL_END
