//
//  CKPBRecommendMoreView.h
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 10/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "CKPhotoBrowserItem.h"

NS_ASSUME_NONNULL_BEGIN

@class CKPBRecommendMoreView;
@protocol CKPBRecommendMoreViewDelegate <NSObject>

@optional

/**
 某一个视图被点击
 @param view 选中button的imageview，可用于的话过渡
 @param photo 选中新的资讯
 */
- (void)moreItemView:(UIImageView *)view didClickOnPhoto:(id<CKPhotoBrowserItem>)photo;

@end

@interface CKPBRecommendMoreView : UIView

/**
 代理
 */
@property (nonatomic, weak, nullable) id<CKPBRecommendMoreViewDelegate> delegate;

/**
 排列显示的items
 */
@property (nonatomic, readonly, nullable) NSArray <id<CKPhotoBrowserItem>> *photos;

/**
 指定初始化方法
 */
- (instancetype)initWithPhotos:(nullable NSArray <id<CKPhotoBrowserItem>>*)photos NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
