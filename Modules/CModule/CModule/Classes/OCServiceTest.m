//
//  OCServiceInSwiftImpl.m
//  CModule
//
//  Created by NeroXie on 2024/7/15.
//

#import "OCServiceTest.h"
#import <CModule/CModule-Swift.h>

@implementation ModuleRegisterService (OCServiceTest)

+ (void)OCServiceTestRegisterService {
    [Module registerService:@protocol(OCServiceInOC) usedClass:OCServiceInOCImpl.class];
    [Module registerService:@protocol(SwiftServiceInOC) usedClass:SwiftServiceInOCImpl.class];
}

@end

@implementation ModuleAwake (OCServiceTest)

+ (void)OCServiceTestAwake {
    [[Module serviceImplOfProtocol:@protocol(OCServiceInOC)] print];
    [[Module serviceImplOfProtocol:@protocol(SwiftServiceInOC)] print];
}

@end

@interface OCServiceInOCImpl () <OCServiceInOC>

@end

@implementation OCServiceInOCImpl

- (void)print {
    NSLog(@"OCServiceInOC");
}

@end

@interface SwiftServiceInOCImpl () <SwiftServiceInOC>

@end

@implementation SwiftServiceInOCImpl

- (void)print {
    NSLog(@"SwiftServiceInOC");
}

@end
