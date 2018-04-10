//
//  XYPhotoBrowserTransitionController.h
//  CKWebPhotoViewer
//
//  Created by Brian Capps on 2/13/15.
//
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 管理动画&交互转换的对象，协调多个动画&交互
 */
@interface XYPhotoBrowserTransitionController : NSObject <UIViewControllerTransitioningDelegate>

/**
 present时，开始图像缩放转场动画的View。View在转场动画中可能隐藏或显示，但不会在视图层次结构中删除或更改
 */
@property (nonatomic) UIView *startingView;

/**
 dismiss时，结束图像缩放转场动画的View。View在转场动画中可能隐藏或显示，但不会在视图层次结构中删除或更改
 */
@property (nonatomic) UIView *endingView;

/**
 是否是手势下滑消失的转场动画来执行dismiss，或主动触发dismissViewController
 */
@property (nonatomic) BOOL forcesNonInteractiveDismissal;

/**
 完成或取消交互式转换回到锚点（endingView）。
 NOTE:需要在 dismissViewControllerAnimated:completion: 方法调用后
 *
 *  @param panGestureRecognizer 下滑消失手势
 *  @param viewToPan            手势locationInView
 *  @param anchorPoint          dismissController调用时的锚点
 */
- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint;

@end

NS_ASSUME_NONNULL_END
