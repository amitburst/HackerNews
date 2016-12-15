/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface MSWrapperSdk : NSObject

/*
 * Version of the wrapper SDK. When the SDK is embedding another base SDK (for example Xamarin.Android wraps Android),
 * the Xamarin specific version is populated into this field while sdkVersion refers to the original Android SDK.
 * [optional]
 */
@property(nonatomic, readonly) NSString *wrapperSdkVersion;

/*
 * Name of the wrapper SDK (examples: Xamarin, Cordova).  [optional]
 */
@property(nonatomic, readonly) NSString *wrapperSdkName;

/*
 * Label that is used to identify application code 'version' released via Live Update beacon running on device
 */
@property(nonatomic, readonly) NSString *liveUpdateReleaseLabel;

/*
 * Identifier of environment that current application release belongs to, deployment key then maps to environment like Production, Staging.
 */
@property(nonatomic, readonly) NSString *liveUpdateDeploymentKey;

/*
 * Hash of all files (ReactNative or Cordova) deployed to device via LiveUpdate beacon.
 * Helps identify the Release version on device or need to download updates in future
 */
@property(nonatomic, readonly) NSString *liveUpdatePackageHash;

/**
 * Is equal to another wrapper SDK
 *
 * @param wrapperSdk Wrapper SDK
 *
 * @return Return YES if equal and NO if not equal
 */
- (BOOL)isEqual:(MSWrapperSdk *)wrapperSdk;

- (instancetype) initWithWrapperSdkVersion:(NSString *)wrapperSdkVersion
                            wrapperSdkName:(NSString *)wrapperSdkName
                    liveUpdateReleaseLabel:(NSString *)liveUpdateReleaseLabel
                   liveUpdateDeploymentKey:(NSString *)liveUpdateDeploymentKey
                     liveUpdatePackageHash:(NSString *)liveUpdatePackageHash;

@end
