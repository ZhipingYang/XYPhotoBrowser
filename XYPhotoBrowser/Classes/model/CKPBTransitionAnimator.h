//
//  CKPBTransitionAnimator.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 控制转场动画，present & dismiss
 */
@interface CKPBTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 开始 image 缩放转场用的view，这里不更改他的属性特征
 */
@property (nonatomic) UIView *startingView;

/**
 结束 image 缩放转场用的view，这里不更改他的属性特征
 */
@property (nonatomic) UIView *endingView;

/**
 开始 image 缩放转场用的view，如果没有设置，默认从startingView截图复制一份（包含部分属性设置复制）
 */
@property (nonatomic, nullable) UIView *startingViewForAnimation;

/**
 结束 image 缩放转场用的view，如果没有设置，默认从endingView截图复制一份（包含部分属性设置复制）
 */
@property (nonatomic, nullable) UIView *endingViewForAnimation;

/**
 dismissing ？ dismissViewController ： presentViewController
 */
@property (nonatomic, getter=isDismissing) BOOL dismissing;

/**
 有startingView或endingView时，转场消失动画时间
 */
@property (nonatomic) CGFloat animationDurationWithZooming;

/**
 没有startingView & endingView，渐隐动画时间
 */
@property (nonatomic) CGFloat animationDurationWithoutZooming;

/**
 range：(0.0 - 1.0)，转场背景消失时间占总时间的比例
 */
@property (nonatomic) CGFloat animationDurationFadeRatio;

/**
 range：(0.0 - 1.0)，endingViewForAnimation fade in 的时间占总时间的比例
 不同图片顺滑过渡的关键比如：startingView和startingViewForAnimation内容不一致
 */
@property (nonatomic) CGFloat animationDurationEndingViewFadeInRatio;

/**
 range：(0.0 - 1.0)，startingViewForAnimation fade out 的时间占总时间的比例，需要在endingViewForAnimationfade in后调用
 不同图片顺滑过渡的关键比如：startingView和startingViewForAnimation内容不一致
 */
@property (nonatomic) CGFloat animationDurationStartingViewFadeOutRatio;

/**
 *  弹簧动画 `animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:` 缩放时的阻尼系数
 */
@property (nonatomic) CGFloat zoomingAnimationSpringDamping;

/**
 用于未设置endingViewForAnimation || startingViewForAnimation 是直接从endingView||startingView拷贝view
 NOTE：
 1.view == imageview 则创建新的imageview
 2.view 有内容则拷贝内容
 3.view!=nil 则截图
 4.view==nil return nil
 *
 *  @param view 用来创建拷贝view的对象.
 *
 *  @return 返回新的view，逻辑上参照NOTE
 */
+ (nullable UIView *)newAnimationViewFromView:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
