//
//  CKPBFunctionView.h
//  CLWebImageBrowserDemo
//
//  Created by XcodeYang on 13/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKPBFunctionView;
@protocol CKPBFunctionViewDelegate <NSObject>
@optional
- (void)functionView:(CKPBFunctionView *)view inputViewDidClick:(UITextField *)inputView;
- (void)functionView:(CKPBFunctionView *)view commentViewDidClick:(UIButton *)commentView;
- (void)functionView:(CKPBFunctionView *)view starViewDidClick:(UIButton *)starView;
- (void)functionView:(CKPBFunctionView *)view shareViewDidClick:(UIButton *)shareView;
@end

@interface CKPBFunctionView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<CKPBFunctionViewDelegate> delegate;

/**
 输入框，用来看的。没有实用。
 真正的输入view通过delegate的inputViewDidClick回调执行弹出
 */
@property (nonatomic, strong) UITextField *inputView;

/**
 评论按钮，评论数由commentNumber显示
 */
@property (nonatomic, strong) UIButton *commentView;

/**
 收藏、点赞
 NOTE:isSelected控制是否收藏
 */
@property (nonatomic, strong) UIButton *starView;

/**
 分享
 */
@property (nonatomic, strong) UIButton *shareView;

/**
 评论数展示
 */
@property (nonatomic) NSInteger commentNumber;

@end
