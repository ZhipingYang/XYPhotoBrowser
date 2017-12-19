//
//  CKPBSinglePhotoDataSource.h
//  CKWebPhotoViewer
//
//  Created by Chris Dzombak on 1/27/17.
//  Copyright © 2017 The New York Times Company. All rights reserved.
//

@import Foundation;

#import "CKPhotoBrowserDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/**
 简易的`CKPhotoBrowserDataSource`代理实现，单个photo的datasource
 */
@interface CKPBSinglePhotoDataSource : NSObject <CKPhotoBrowserDataSource>

@property (nonatomic, readonly) id<CKPhotoBrowserItem> photo;

/*
 指定构造器
 */
- (instancetype)initWithPhoto:(id<CKPhotoBrowserItem>)photo NS_DESIGNATED_INITIALIZER;

+ (instancetype)dataSourceWithPhoto:(id<CKPhotoBrowserItem>)photo;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
