//
//  OCService.h
//  CModule
//
//  Created by NeroXie on 2024/7/15.
//

#import <Foundation/Foundation.h>
#import <NNModule_swift/NNModule_swift-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCServiceInOC <ModuleFunctionalService>

- (void)print;

@end

@protocol OCServiceInSwift <ModuleFunctionalService>

- (void)print;

@end

@interface OCServiceInOCImpl : NSObject

@end

@interface SwiftServiceInOCImpl : NSObject

@end

NS_ASSUME_NONNULL_END
