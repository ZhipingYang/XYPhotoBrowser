//
//  XYPBRecommendMoreView.h
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 10/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserContentView.h"
#import "PhotoItem.h"

NS_ASSUME_NONNULL_BEGIN

@class XYPBRecommendMoreView;
@protocol XYPBRecommendMoreViewDelegate <NSObject>

@optional

/**
 某一个视图被点击
 @param view 选中button的imageview，可用于的话过渡
 @param photo 选中新的资讯
 */
- (void)moreItemView:(UIImageView *)view didClickOnPhoto:(id<XYPhotoBrowserItem>)photo;

@end


@interface XYPBRecommendMoreView : UIView <XYPhotoBrowserContentView>

/**
 代理
 */
@property (nonatomic, weak, nullable) id<XYPBRecommendMoreViewDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
