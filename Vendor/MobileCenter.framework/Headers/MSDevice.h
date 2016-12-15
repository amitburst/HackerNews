/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "MSWrapperSdk.h"
#import <Foundation/Foundation.h>

@interface MSDevice : MSWrapperSdk

/*
 * Name of the SDK. Consists of the name of the SDK and the platform, e.g. "mobilecenter.ios", "mobilecenter.android"
 */
@property(nonatomic, readonly) NSString *sdkName;

/*
 * Version of the SDK in semver format, e.g. "1.2.0" or "0.12.3-alpha.1".
 */
@property(nonatomic, readonly) NSString *sdkVersion;

/*
 * Device model (example: iPad2,3).
 */
@property(nonatomic, readonly) NSString *model;

/*
 * Device manufacturer (example: HTC).
 */
@property(nonatomic, readonly) NSString *oemName;

/*
 * OS name (example: iOS).
 */
@property(nonatomic, readonly) NSString *osName;

/*
 * OS version (example: 9.3.0).
 */
@property(nonatomic, readonly) NSString *osVersion;

/*
 * OS build code (example: LMY47X).  [optional]
 */
@property(nonatomic, readonly) NSString *osBuild;

/*
 * API level when applicable like in Android (example: 15).  [optional]
 */
@property(nonatomic, readonly) NSNumber *osApiLevel;

/*
 * Language code (example: en_US).
 */
@property(nonatomic, readonly) NSString *locale;

/*
 * The offset in minutes from UTC for the device time zone, including daylight savings time.
 */
@property(nonatomic, readonly) NSNumber *timeZoneOffset;

/*
 * Screen size of the device in pixels (example: 640x480).
 */
@property(nonatomic, readonly) NSString *screenSize;

/*
 * Application version name, e.g. 1.1.0
 */
@property(nonatomic, readonly) NSString *appVersion;

/*
 * Carrier name (for mobile devices).  [optional]
 */
@property(nonatomic, readonly) NSString *carrierName;

/*
 * Carrier country code (for mobile devices).  [optional]
 */
@property(nonatomic, readonly) NSString *carrierCountry;

/*
 * The app's build number, e.g. 42.
 */
@property(nonatomic, readonly) NSString *appBuild;

/*
 * The bundle identifier, package identifier, or namespace, depending on what the individual plattforms use,  .e.g
 * com.microsoft.example.  [optional]
 */
@property(nonatomic, readonly) NSString *appNamespace;

/**
 * Is equal to another device log
 *
 * @param device Device log
 *
 * @return Return YES if equal and NO if not equal
 */
- (BOOL)isEqual:(MSDevice *)device;

@end
