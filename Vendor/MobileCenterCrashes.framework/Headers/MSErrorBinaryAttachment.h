/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>

/*
 * Binary attachment for error log.
 */
@interface MSErrorBinaryAttachment : NSObject

/**
 * The fileName for binary data.
 */
@property(nonatomic, readonly, nullable) NSString *fileName;

/**
 * Binary data.
 */
@property(nonatomic, readonly, nonnull) NSData *data;

/**
 * Content type for binary data.
 */
@property(nonatomic, readonly, nonnull) NSString *contentType;

/**
 * Is equal to another error binary attachment
 *
 * @param attachment Error binary attachment
 *
 * @return Return YES if equal and NO if not equal
 */
- (BOOL)isEqual:(nullable MSErrorBinaryAttachment *)attachment;

/**
 * Create an MSErrorBinaryAttachment instance with a given filename and NSData object
 * @param fileName The filename the attachment should get. If nil will get an automatically generated filename
 * @param data The attachment data as NSData.
 * @param contentType The content type of your data as MIME type.
 *
 * @return An instance of MSErrorBinaryAttachment.
 */
- (nonnull instancetype)initWithFileName:(nullable NSString *)fileName
                          attachmentData:(nonnull NSData *)data
                             contentType:(nonnull NSString *)contentType;

@end
