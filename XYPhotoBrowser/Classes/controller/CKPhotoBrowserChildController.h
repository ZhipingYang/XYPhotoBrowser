//
//  CKPhotoBrowserChildController.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "CKPhotoBrowserContainer.h"
#import "CKPBRecommendMoreView.h"
@import UIKit;
@class CKPBScalingImageView;

@protocol CKPhotoBrowserItem;
@protocol CKPhotoBrowserChildControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 `CKPhotoBrowserChildController`作为观察者，接受通知并处理通知携带的 `id <CKPhotoBrowserItem>` 对象
 */
extern NSString * const CKPhotoBrowserChildControllerPhotoImageUpdatedNotification;

/**
 单一图片展示的controller
 */
@interface CKPhotoBrowserChildController : UIViewController <CKPhotoBrowserContainer>

/**
 图片缩放承载的scrollView子类
 */
@property (nonatomic, readonly) CKPBScalingImageView *scalingImageView;

/**
 加载等待view
 */
@property (nonatomic, readonly, nullable) UIView *loadingView;

/**
 双击用来缩放图片
 */
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

/**
 controller's delegate.
 */
@property (nonatomic, weak, nullable) id <CKPhotoBrowserChildControllerDelegate> delegate;

/**
 *  指定构造器
 *
 *  @param photo              photo对象
 *  @param loadingView        自定义加载等待view
 *  @param notificationCenter 对`CKPhotoBrowserChildControllerPhotoImageUpdatedNotification`的观察的通知.
 *
 *  @return 实例.
 */
- (instancetype)initWithPhoto:(nullable id <CKPhotoBrowserItem>)photo loadingView:(nullable UIView *)loadingView notificationCenter:(nullable NSNotificationCenter *)notificationCenter NS_DESIGNATED_INITIALIZER;

@end

@protocol CKPhotoBrowserChildControllerDelegate <CKPBRecommendMoreViewDelegate>

@optional

/**
 长按手势回调
 *  @param photoViewController        CKPhotoBrowserChildController 实例.
 *  @param longPressGestureRecognizer 长按手势.
 */
- (void)photoViewController:(CKPhotoBrowserChildController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
