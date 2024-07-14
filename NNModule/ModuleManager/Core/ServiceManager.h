//
//  NNServiceManager.h
//  ModuleManagment
//
//  Created by NeroXie on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import "ModuleBasicService.h"

NS_ASSUME_NONNULL_BEGIN

//struct ServiceIdentifier {
//    NSString *value;
//};
//
//ServiceIdentifierMake
//
//typedef struct CG_BOXABLE CGSize CGSize;


@interface ServiceManager : NSObject

@property (nonatomic, strong, readonly, class) ServiceManager *sharedInstance NS_SWIFT_NAME(shared);

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (void)registerServiceWithIdentifier:(NSString *)identifier implClass:(Class)implClass NS_SWIFT_NAME(registerService(with:implClass:));

- (void)removeServiceWithIdentifier:(NSString *)identifier NS_SWIFT_NAME(removeService(with:));

- (nullable id<ModuleFunctionalService>)serviceImplOfIdentifier:(NSString *)identifier NS_SWIFT_NAME(serviceImpl(of:));

- (nullable id<ModuleFunctionalService>)serviceNativeImplOfIdentifier:(NSString *)identifier NS_SWIFT_NAME(serviceNativeImpl(of:));

- (nullable id<ModuleRegisteredService>)registerImplOfClass:(Class)implClass NS_SWIFT_NAME(registerImpl(of:));;

- (void)bridgeMethod:(SEL)method isClassMethod:(BOOL)isClassMethod identifier:(NSString *)identifier usedClass:(Class)aClass;

- (void)serviceInfoPrettyPrinted;

@end

NS_ASSUME_NONNULL_END
