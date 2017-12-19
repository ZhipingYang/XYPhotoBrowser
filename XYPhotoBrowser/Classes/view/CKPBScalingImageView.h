//
//  CKPBScalingImageView.h
//  CKWebPhotoViewer
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

@import UIKit;
#import "CKPhotoBrowserItem.h"

#ifdef ANIMATED_GIF_SUPPORT
@class FLAnimatedImageView;
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CKPBScalingImageView : UIScrollView

/**
 scrollView 的内容
 */
#ifdef ANIMATED_GIF_SUPPORT
@property (nonatomic, readonly) FLAnimatedImageView *imageView;
#else
@property (nonatomic, readonly) UIImageView *imageView;
#endif

/**
 指定构造器, scrollView 中包含 imageview作为content
 @param image 缩放滑动的image
 @param frame imageview.frame

 @return CKPBScalingImageView.
 */
- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

/**
 指定构造器, scrollView 中包含 imageview作为content
 @param imageData 缩放滑动的imageData
 @param frame imageview.frame
 
 @return CKPBScalingImageView.
 */
- (instancetype)initWithImageData:(NSData *)imageData frame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (void)updateImage:(UIImage *)image;

- (void)updateImageData:(NSData *)imageData;

/**
 imageView居中调整（更新、zoom后调用）
 */
- (void)centerScrollViewContents;

@end

NS_ASSUME_NONNULL_END
