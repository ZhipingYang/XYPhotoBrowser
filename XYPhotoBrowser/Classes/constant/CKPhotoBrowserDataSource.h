//
//  CKPhotoBrowserControllerDataSource.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;

@protocol CKPhotoBrowserItem;

NS_ASSUME_NONNULL_BEGIN

/**
 `CKPhotoBrowserController` 的 datasource
 简单使用可以直接用`CKPBArrayDataSource` 和 `CKPBSinglePhotoDataSource`
 */
@protocol CKPhotoBrowserDataSource

@property (nonatomic, readonly, nullable) NSNumber *numberOfPhotos;

/**
 查找photo的index，如果没有则返回NSNotFound
 
 @param photo 查找对象.
 
 @return photo的index，没有则返回`NSNotFound`
 */
- (NSInteger)indexOfPhoto:(id <CKPhotoBrowserItem>)photo;

/**
 查找角标下index的photo，如果没有则返回nil
 
 @param photoIndex datasource集合的index.
 
 @return 返回index下的结果
 */
- (nullable id <CKPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex;

@end

NS_ASSUME_NONNULL_END
