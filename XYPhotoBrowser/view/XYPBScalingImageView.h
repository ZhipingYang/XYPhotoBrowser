//
//  XYPBScalingImageView.h
//  CKWebPhotoViewer
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

#import "XYPhotoBrowserItem.h"
#import "XYPhotoBrowserContentView.h"

#ifdef ANIMATED_GIF_SUPPORT
@class FLAnimatedImageView;
#endif

NS_ASSUME_NONNULL_BEGIN

@interface XYPBScalingImageView : UIScrollView <XYPhotoBrowserContentView>

/**
 imageView居中调整（更新、zoom后调用）
 */
- (void)centerScrollViewContents;

- (id)initWithPhoto:(id<XYPhotoBrowserItem>)photo NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));
+ (instancetype)new __attribute__((unavailable("此方法已弃用,请使用 initWithPhoto")));;

@end

NS_ASSUME_NONNULL_END
