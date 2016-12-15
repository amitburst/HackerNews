/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "MSServiceAbstract.h"
#import <UIKit/UIKit.h>

/**
 *  Mobile Center analytics service.
 */
@interface MSAnalytics : MSServiceAbstract

/**
 *  Track an event.
 *
 *  @param eventName  event name.
 */
+ (void)trackEvent:(NSString *)eventName;

/**
 *  Track an event.
 *
 *  @param eventName  event name.
 *  @param properties dictionary of properties.
 */
+ (void)trackEvent:(NSString *)eventName withProperties:(NSDictionary *)properties;

@end
