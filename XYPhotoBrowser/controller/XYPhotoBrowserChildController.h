//
//  XYPhotoBrowserChildController.h
//  CKWebPhotoViewer
//
//  Created by XcodeYang on 08/11/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

#import "XYPhotoBrowserContentView.h"

@import UIKit;

@protocol XYPhotoBrowserChildControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 `XYPhotoBrowserChildController`作为观察者，接受通知并处理通知携带的 `id <XYPhotoBrowserItem>` 对象
 */
extern NSString * const XYPhotoBrowserChildControllerPhotoImageUpdatedNotification;

/**
 单一图片展示的controller
 */
@interface XYPhotoBrowserChildController : UIViewController <XYPhotoBrowserContainer>

/**
 图片缩放承载的scrollView子类
 */
@property (nonatomic, strong, nullable) UIView <XYPhotoBrowserContentView> *scalingImageView;

/**
 加载等待view
 */
@property (nonatomic, strong, nullable) UIView *loadingView;

/**
 事件通知
 */
@property (nonatomic, weak, nullable) NSNotificationCenter *notificationCenter;

/**
 双击用来缩放图片
 */
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

/**
 controller's delegate.
 */
@property (nonatomic, weak, nullable) id <XYPhotoBrowserChildControllerDelegate> delegate;

@end

@protocol XYPhotoBrowserChildControllerDelegate <NSObject>

@optional

/**
 长按手势回调
 *  @param photoViewController        XYPhotoBrowserChildController 实例.
 *  @param longPressGestureRecognizer 长按手势.
 */
- (void)photoViewController:(XYPhotoBrowserChildController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
