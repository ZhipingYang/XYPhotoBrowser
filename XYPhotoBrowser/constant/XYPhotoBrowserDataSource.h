//
//  XYPhotoBrowserControllerDataSource.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;

@protocol XYPhotoBrowserItem;

NS_ASSUME_NONNULL_BEGIN

/**
 `XYPhotoBrowserController` 的 datasource
 简单使用可以直接用`XYPBArrayDataSource` 和 `XYPBSinglePhotoDataSource`
 */
@protocol XYPhotoBrowserDataSource

@property (nonatomic, readonly) NSInteger numberOfPhotos;

/**
 查找photo的index，如果没有则返回NSNotFound
 
 @param photo 查找对象.
 
 @return photo的index，没有则返回`NSNotFound`
 */
- (NSInteger)indexOfPhoto:(id <XYPhotoBrowserItem>)photo;

/**
 查找角标下index的photo，如果没有则返回nil
 
 @param photoIndex datasource集合的index.
 
 @return 返回index下的结果
 */
- (nullable id <XYPhotoBrowserItem>)photoAtIndex:(NSInteger)photoIndex;


/**
 接受到内存警告，可以的话，释放XYPhotoBrowserItem的unloadUnderlyingImage
 */
- (void)didReceiveMemoryWarning;

@end

NS_ASSUME_NONNULL_END
