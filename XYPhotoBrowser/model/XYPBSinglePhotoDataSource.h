//
//  XYPBSinglePhotoDataSource.h
//  CKWebPhotoViewer
//
//  Created by Chris Dzombak on 1/27/17.
//  Copyright © 2017 The New York Times Company. All rights reserved.
//

@import Foundation;

#import "XYPhotoBrowserDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/**
 简易的`XYPhotoBrowserDataSource`代理实现，单个photo的datasource
 */
@interface XYPBSinglePhotoDataSource : NSObject <XYPhotoBrowserDataSource>

@property (nonatomic, readonly) id<XYPhotoBrowserItem> photo;

/*
 指定构造器
 */
- (instancetype)initWithPhoto:(id<XYPhotoBrowserItem>)photo NS_DESIGNATED_INITIALIZER;

+ (instancetype)dataSourceWithPhoto:(id<XYPhotoBrowserItem>)photo;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
