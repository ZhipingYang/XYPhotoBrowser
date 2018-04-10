//
//  XYPhotoBrowserContainer.h
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserItem.h"
#import "XYPhotoBrowserContainer.h"

#ifdef ANIMATED_GIF_SUPPORT
@class FLAnimatedImageView;
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol XYPhotoBrowserContentView <XYPhotoBrowserContainer>

@optional

// imageView
#ifdef ANIMATED_GIF_SUPPORT
@property (nonatomic, readonly, nullable) FLAnimatedImageView *imageView;
#else
@property (nonatomic, readonly, nullable) UIImageView *imageView;
#endif

// scrollView
@property (nonatomic) CGFloat maximumZoomScale;
@property (nonatomic, readonly) CGFloat zoomScale;
@property (nonatomic, readonly) CGFloat minimumZoomScale;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

@required

/**
 指定构造器, scrollView 中包含 imageview作为content
 
 @param photo 数据
 @return 实例
 */
- (id)initWithPhoto:(id<XYPhotoBrowserItem>)photo;

/**
 更新 imageview 的 image 或 imageData
 @param photo 数据
 */
- (void)updatePhoto:(nullable id<XYPhotoBrowserItem>)photo;

@end

NS_ASSUME_NONNULL_END
