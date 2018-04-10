//
//  XYPBDefaultFunctionView.h
//  XYImageBrowserDemo
//
//  Created by XcodeYang on 13/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserViewResize.h"

@class XYPBDefaultFunctionView;

NS_ASSUME_NONNULL_BEGIN

@protocol XYPBDefaultFunctionViewDelegate <NSObject>

@optional
- (void)functionView:(XYPBDefaultFunctionView *)view inputViewDidClick:(UITextField *)inputView;

- (void)functionView:(XYPBDefaultFunctionView *)view commentViewDidClick:(UIButton *)commentView;

- (void)functionView:(XYPBDefaultFunctionView *)view starViewDidClick:(UIButton *)starView;

- (void)functionView:(XYPBDefaultFunctionView *)view shareViewDidClick:(UIButton *)shareView;

@end

@interface XYPBDefaultFunctionView : UIView <XYPhotoBrowserViewResize>

/**
 代理
 */
@property (nonatomic, weak) id<XYPBDefaultFunctionViewDelegate> delegate;

/**
 输入框，用来看的。没有实用
 真正的输入view通过delegate的inputViewDidClick回调执行弹出
 */
@property (nonatomic, readonly) UITextField *inputView;

/**
 评论按钮，评论数由commentNumber显示
 */
@property (nonatomic, readonly) UIButton *commentView;

/**
 收藏、点赞
 NOTE:isSelected控制是否收藏
 */
@property (nonatomic, readonly) UIButton *starView;

/**
 分享
 */
@property (nonatomic, readonly) UIButton *shareView;

/**
 评论数展示
 */
@property (nonatomic) NSInteger commentNumber;

@end

NS_ASSUME_NONNULL_END
