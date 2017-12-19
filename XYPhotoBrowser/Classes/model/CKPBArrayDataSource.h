//
//  CKPBArrayDataSource.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//  Copyright (c) 2017 The New York Times Company. All rights reserved.
//

@import Foundation;

#import "CKPhotoBrowserDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/**
 简易的`CKPhotoBrowserDataSource`代理实现，不需要获取在线数据，直接赋值 photos
 */
@interface CKPBArrayDataSource : NSObject <CKPhotoBrowserDataSource, NSFastEnumeration>

@property (nonatomic, readonly) NSArray<id<CKPhotoBrowserItem>> *photos;

/*
 指定构造器
 */
- (instancetype)initWithPhotos:(nullable NSArray<id<CKPhotoBrowserItem>> *)photos NS_DESIGNATED_INITIALIZER;

+ (instancetype)dataSourceWithPhotos:(nullable NSArray<id<CKPhotoBrowserItem>> *)photos;

/**
 集合下标语法糖支持（小心越界）
 @return CKPhotoBrowserItem 实例
 */
- (id<CKPhotoBrowserItem>)objectAtIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
